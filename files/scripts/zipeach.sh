#!/usr/bin/env sh
set -eu

DELETE_SOURCE=0

usage() {
  echo "Usage: $0 [-d] <target-dir>"
  echo "  -d    delete source directory after zipping"
  exit 1
}

while getopts "d" opt; do
  case "$opt" in
    d) DELETE_SOURCE=1 ;;
    *) usage ;;
  esac
done

shift $((OPTIND - 1))

TARGET_DIR="${1:-}"
[ -n "$TARGET_DIR" ] || usage

for dir in "$TARGET_DIR"/*/; do
  [ -d "$dir" ] || continue

  name=$(basename "$dir")
  zipfile="$TARGET_DIR/$name.zip"

  echo "Zipping $dir -> $zipfile"

  if zip -r "$zipfile" "$dir"; then
    if [ "$DELETE_SOURCE" -eq 1 ]; then
      echo "Deleting $dir"
      rm -rf "$dir"
    fi
  else
    echo "Failed to zip $dir"
  fi
done
