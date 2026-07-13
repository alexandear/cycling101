#!/bin/sh
set -e

if ! command -v cwebp >/dev/null 2>&1; then
  echo "Error: cwebp is not installed" >&2
  echo "Install it from https://developers.google.com/speed/webp/docs/precompiled" >&2
  exit 1
fi

IMG_DIR="$(CDPATH= cd -- "$(dirname "$0")/../images" && pwd)"

for img in "$IMG_DIR"/*.jpg "$IMG_DIR"/*.jpeg "$IMG_DIR"/*.png \
           "$IMG_DIR"/*.JPG "$IMG_DIR"/*.JPEG "$IMG_DIR"/*.PNG; do
  [ -e "$img" ] || continue
  webp="${img%.*}.webp"
  cwebp -quiet "$img" -o "$webp"
done
