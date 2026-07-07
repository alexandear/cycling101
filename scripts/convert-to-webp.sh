#!/bin/sh
set -e

IMG_DIR="$(CDPATH= cd -- "$(dirname "$0")/../images" && pwd)"

for img in "$IMG_DIR"/*.jpg "$IMG_DIR"/*.jpeg "$IMG_DIR"/*.png \
           "$IMG_DIR"/*.JPG "$IMG_DIR"/*.JPEG "$IMG_DIR"/*.PNG; do
  [ -e "$img" ] || continue
  webp="${img%.*}.webp"
  cwebp -quiet "$img" -o "$webp"
done
