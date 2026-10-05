#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/skills"
DEST="$HOME/.agents/skills"

if [ ! -d "$SRC" ]; then
  echo "Source folder not found: $SRC" >&2
  exit 1
fi

count=$(find "$SRC" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
if [ "$count" -eq 0 ]; then
  echo "No skills found in $SRC" >&2
  exit 1
fi

if [ "${1:-}" = "--dry-run" ]; then
  echo "Dry run: would clean $DEST and copy $count skills:"
  ls -1 "$SRC"
  exit 0
fi

mkdir -p "$DEST"
# Clean destination (safe-guarded against empty $DEST)
rm -rf "${DEST:?}/"*
cp -R "$SRC/"* "$DEST/"

echo "Installed $count skills to $DEST"
