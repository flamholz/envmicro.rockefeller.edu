#!/usr/bin/env bash
# Check the built site in _site/ with html-proofer.
#
#   scripts/check-links.sh             internal links, images, scripts (fast, offline)
#   scripts/check-links.sh --external  also check external links (slow; some
#                                      publishers block bots, so expect noise)
#
# Run scripts/build.sh first.

set -euo pipefail
cd "$(dirname "$0")/.."

# read/write files as UTF-8 regardless of the shell locale
export RUBYOPT="-EUTF-8 ${RUBYOPT:-}"
export LANG="${LANG:-en_US.UTF-8}"

[[ -d _site ]] || { echo "No _site/ directory. Run scripts/build.sh first." >&2; exit 1; }

# use the same ruby that build.sh would find
if ! ruby -e 'exit(RUBY_VERSION >= "3.1" ? 0 : 1)' 2>/dev/null; then
  for dir in /opt/homebrew/opt/ruby@3.4/bin /usr/local/opt/ruby@3.4/bin; do
    [[ -x "$dir/ruby" ]] && export PATH="$dir:$PATH" && break
  done
fi
BUNDLER_VERSION="$(grep -A1 'BUNDLED WITH' Gemfile.lock | tail -n1 | tr -d ' ')"

ARGS=(
  --allow-missing-href
  --no-enforce-https
  # root-relative links resolve against _site/ as if it were the docroot
  --root-dir "$(pwd)/_site"
  --ignore-urls '/fonts\.gstatic\.com/,/localhost:/,/127\.0\.0\.1:/'
)
if [[ "${1:-}" != "--external" ]]; then
  ARGS+=(--disable-external)
fi

bundle "_${BUNDLER_VERSION}_" exec htmlproofer "${ARGS[@]}" _site
