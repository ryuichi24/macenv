#!/usr/bin/env sh

set -eu

TARGET_DIR="${1:-}"

if [ -z "$TARGET_DIR" ]; then
  echo "Usage: $0 <target-dir>"
  exit 1
fi

for dir in "$TARGET_DIR"/*/; do
  [ -d "$dir" ] || continue
  echo "Deleting $dir"
  rm -rf "$dir"
done
