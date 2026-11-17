#!/usr/bin/env bash
# Build the static site into _site/.
#
#   1. install pinned Ruby gems (Gemfile.lock) into vendor/bundle
#   2. install pinned Python packages (requirements.txt) into .venv
#   3. run the citation step: _data/sources.yaml -> _data/citations.yaml
#   4. JEKYLL_ENV=production bundle exec jekyll build  -> _site/
#
# The output in _site/ (including .htaccess) can be copied as-is into the
# root of an Apache docroot.
#
# Options (environment variables):
#   SKIP_CITE=1     skip step 3 and use the committed _data/citations.yaml
#                   (e.g. when offline)
#   RUBY_BIN_DIR    directory containing ruby >= 3.1 if it is not first on PATH
#   PYTHON          python >= 3.10 to create .venv with (default: first found)

set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$(pwd)"

# read/write files as UTF-8 regardless of the shell locale
export RUBYOPT="-EUTF-8 ${RUBYOPT:-}"
export LANG="${LANG:-en_US.UTF-8}"

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
die() { printf '\n\033[1;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

# ---------------------------------------------------------------- ruby ----
log "Checking Ruby"

ruby_ok() { "$1" -e 'exit(Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.1") ? 0 : 1)' 2>/dev/null; }

if [[ -n "${RUBY_BIN_DIR:-}" ]]; then
  export PATH="$RUBY_BIN_DIR:$PATH"
fi
if ! command -v ruby >/dev/null || ! ruby_ok ruby; then
  # common Homebrew locations (macOS system ruby 2.6 is too old)
  for dir in /opt/homebrew/opt/ruby@3.4/bin /usr/local/opt/ruby@3.4/bin \
             /opt/homebrew/opt/ruby/bin /usr/local/opt/ruby/bin; do
    if [[ -x "$dir/ruby" ]] && ruby_ok "$dir/ruby"; then
      export PATH="$dir:$PATH"
      break
    fi
  done
fi
ruby_ok ruby || die "Ruby >= 3.1 is required (template targets 3.4; see .ruby-version).
  macOS:  brew install ruby@3.4   (or set RUBY_BIN_DIR)"
echo "ruby $(ruby -e 'print RUBY_VERSION') at $(command -v ruby)"

BUNDLER_VERSION="$(grep -A1 'BUNDLED WITH' Gemfile.lock | tail -n1 | tr -d ' ')"
if ! gem list bundler -i -v "$BUNDLER_VERSION" >/dev/null 2>&1; then
  log "Installing bundler $BUNDLER_VERSION"
  gem install bundler -v "$BUNDLER_VERSION" --no-document
fi
BUNDLE=(bundle "_${BUNDLER_VERSION}_")

log "Installing Ruby gems (vendor/bundle)"
"${BUNDLE[@]}" config set --local path vendor/bundle >/dev/null
if [[ "$(uname)" == "Darwin" ]] && command -v xcrun >/dev/null; then
  # some Command Line Tools installs don't put the C++ headers on the default
  # include path, which breaks the eventmachine native extension
  SDK="$(xcrun --show-sdk-path 2>/dev/null || true)"
  if [[ -n "$SDK" && -d "$SDK/usr/include/c++/v1" ]]; then
    export SDKROOT="$SDK"
    export CPLUS_INCLUDE_PATH="$SDK/usr/include/c++/v1${CPLUS_INCLUDE_PATH:+:$CPLUS_INCLUDE_PATH}"
  fi
fi
"${BUNDLE[@]}" install --quiet

# -------------------------------------------------------------- python ----
if [[ "${SKIP_CITE:-0}" != "1" ]]; then
  log "Setting up Python venv (.venv)"
  py_ok() { "$1" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' 2>/dev/null; }
  # an existing venv built with an older python can't install the pins
  if [[ -x .venv/bin/python ]] && ! py_ok .venv/bin/python; then
    echo "removing .venv (python too old)"
    rm -rf .venv
  fi
  if [[ ! -x .venv/bin/python ]]; then
    if [[ -z "${PYTHON:-}" ]]; then
      for cand in python3 python3.13 python3.12 python3.11 python3.10 \
                  /opt/homebrew/bin/python3 /usr/local/bin/python3; do
        if command -v "$cand" >/dev/null && py_ok "$cand"; then PYTHON="$cand"; break; fi
      done
    fi
    [[ -n "${PYTHON:-}" ]] && py_ok "$PYTHON" || die "Python >= 3.10 is required for the citation step.
  Install one (e.g. brew install python@3.12) or set PYTHON=/path/to/python3, or use SKIP_CITE=1."
    echo "creating .venv with $("$PYTHON" --version) ($(command -v "$PYTHON"))"
    "$PYTHON" -m venv .venv
  fi
  .venv/bin/python -m pip install --quiet --upgrade pip
  .venv/bin/python -m pip install --quiet --requirement requirements.txt

  log "Generating citations (_data/sources.yaml -> _data/citations.yaml)"
  # cite.py calls the `manubot` CLI, so the venv must be on PATH
  PATH="$ROOT/.venv/bin:$PATH" python _cite/cite.py
else
  log "SKIP_CITE=1: using committed _data/citations.yaml"
fi

# --------------------------------------------------------------- jekyll ----
log "Building site (JEKYLL_ENV=production)"
rm -rf _site
JEKYLL_ENV=production "${BUNDLE[@]}" exec jekyll build

[[ -f _site/index.html ]] || die "_site/index.html missing after build"
[[ -f _site/.htaccess ]] || die "_site/.htaccess missing after build"
[[ -f _site/404.html ]] || die "_site/404.html missing after build"

log "Done: $(find _site -type f | wc -l | tr -d ' ') files in _site/ ($(du -sh _site | cut -f1))"
