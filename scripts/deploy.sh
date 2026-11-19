#!/usr/bin/env bash
# Deploy the built site to the RU self-host web server.
#
#   scripts/deploy.sh                 build, then PREVIEW what would change (no upload)
#   scripts/deploy.sh --go            build, then upload
#   scripts/deploy.sh --no-build ...  skip the build and deploy the current _site/
#
# Server: ruselfhost-2023.rockefeller.edu, login flamholz_curator (SSH keys only;
# see MIGRATION_NOTES.md). Files are mirrored into the Apache docroot:
#   /WWW/sites/envmicro.rockefeller.edu/htdocs/
#
# Mirroring uses rsync over SSH with --delete, so files removed from the site are
# removed from the server too. Server-side paths listed in PROTECT are never
# touched, and a run that would delete more than MAX_DELETE files stops.
#
# Options (environment variables):
#   DEPLOY_HOST   default ruselfhost-2023.rockefeller.edu
#   DEPLOY_USER   default flamholz_curator
#   DEPLOY_PATH   default /WWW/sites/envmicro.rockefeller.edu/htdocs/
#   SSH_KEY       private key to use (default: ssh's usual keys / ~/.ssh/config)
#   MAX_DELETE    default 200
#   SKIP_CITE=1   passed to scripts/build.sh (use the committed citations)

set -euo pipefail

cd "$(dirname "$0")/.."

DEPLOY_HOST="${DEPLOY_HOST:-ruselfhost-2023.rockefeller.edu}"
DEPLOY_USER="${DEPLOY_USER:-flamholz_curator}"
DEPLOY_PATH="${DEPLOY_PATH:-/WWW/sites/envmicro.rockefeller.edu/htdocs/}"
MAX_DELETE="${MAX_DELETE:-200}"
# server-side paths the mirror must never delete or overwrite
PROTECT=(".well-known/" "cgi-bin/")

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mWARNING: %s\033[0m\n' "$*" >&2; }
die() { printf '\n\033[1;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

GO=0
BUILD=1
for arg in "$@"; do
  case "$arg" in
    --go) GO=1 ;;
    --no-build) BUILD=0 ;;
    -h|--help) sed -n '2,23p' "$0"; exit 0 ;;
    *) die "unknown option: $arg (see --help)" ;;
  esac
done

[[ "$DEPLOY_PATH" == */ ]] || DEPLOY_PATH="$DEPLOY_PATH/"
TARGET="$DEPLOY_USER@$DEPLOY_HOST"

SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout=15)
[[ -n "${SSH_KEY:-}" ]] && SSH_OPTS+=(-i "$SSH_KEY" -o IdentitiesOnly=yes)

# -------------------------------------------------------------- checks ----
if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
  warn "the working tree has uncommitted changes; they will be deployed too"
fi

log "Checking SSH access to $TARGET"
ssh "${SSH_OPTS[@]}" "$TARGET" true 2>/dev/null \
  || die "cannot log in to $TARGET with your SSH key.
  Has IT installed your public key for $DEPLOY_USER? Test with:
    ssh $TARGET"

ssh "${SSH_OPTS[@]}" "$TARGET" "test -d '$DEPLOY_PATH' && test -w '$DEPLOY_PATH'" \
  || die "$DEPLOY_PATH does not exist on the server or is not writable by $DEPLOY_USER"

ssh "${SSH_OPTS[@]}" "$TARGET" "command -v rsync >/dev/null" \
  || die "rsync is not installed on the server. Ask IT to install it, or upload
  _site/ with an SFTP client (e.g. Cyberduck/FileZilla) to $DEPLOY_PATH"

# --------------------------------------------------------------- build ----
if [[ "$BUILD" == 1 ]]; then
  log "Building the site"
  scripts/build.sh
fi
[[ -f _site/index.html && -f _site/.htaccess ]] \
  || die "_site/ is missing or incomplete; run scripts/build.sh first"

# -------------------------------------------------------------- deploy ----
RSYNC_OPTS=(
  -rlptz                          # recurse, links, perms, times, compress (no owner/group)
  --delete-after                  # remove server files no longer in _site/, after copying
  --max-delete="$MAX_DELETE"
  --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r   # world-readable for Apache
  --itemize-changes
  -e "ssh ${SSH_OPTS[*]}"
)
for p in "${PROTECT[@]}"; do RSYNC_OPTS+=(--exclude="/$p"); done

if [[ "$GO" == 0 ]]; then
  log "PREVIEW (dry run): changes that --go would make on $TARGET:$DEPLOY_PATH"
  rsync "${RSYNC_OPTS[@]}" --dry-run _site/ "$TARGET:$DEPLOY_PATH"
  printf '\nNothing was uploaded. Lines starting "*deleting" are files that would be\nremoved from the server. Run again with --go to deploy.\n'
else
  log "Deploying _site/ to $TARGET:$DEPLOY_PATH"
  rsync "${RSYNC_OPTS[@]}" _site/ "$TARGET:$DEPLOY_PATH"
  log "Done: https://envmicro.rockefeller.edu/"
fi
