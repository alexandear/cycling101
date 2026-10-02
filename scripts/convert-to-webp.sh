#!/bin/sh
set -e

if ! command -v cwebp >/dev/null 2>&1; then
  echo "Error: cwebp is not installed" >&2
  echo "Install it from https://developers.google.com/speed/webp/docs/precompiled" >&2
  exit 1
fi

IMG_DIR="$(CDPATH= cd -- "$(dirname "$0")/../images" && pwd)"

# Recursive: images/ has per-section subfolders (images/blog, ...).
find "$IMG_DIR" -type f \
  \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) |
while read -r img; do
  webp="${img%.*}.webp"
  cwebp -quiet "$img" -o "$webp"
done
