#!/bin/sh
set -e

if ! command -v ffmpeg >/dev/null 2>&1 || ! command -v ffprobe >/dev/null 2>&1; then
  echo "Error: ffmpeg is not installed" >&2
  echo "Install it from https://ffmpeg.org/download.html" >&2
  exit 1
fi

if ! command -v cwebp >/dev/null 2>&1; then
  echo "Error: cwebp is not installed" >&2
  echo "Install it from https://developers.google.com/speed/webp/docs/precompiled" >&2
  exit 1
fi

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
VIDEO_DIR="$ROOT/videos"
IMG_DIR="$ROOT/images"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Recursive: videos/ has per-section subfolders, and each poster lands in the
# matching images/ subfolder.
find "$VIDEO_DIR" -type f \
  \( -iname '*.mp4' -o -iname '*.mov' -o -iname '*.webm' \) |
while read -r video; do
  rel="${video#"$VIDEO_DIR"/}"
  poster="$IMG_DIR/${rel%.*}_poster.webp"
  mkdir -p "$(dirname "$poster")"

  # Rebuild only when the clip is newer than its poster.
  if [ -e "$poster" ] && [ "$poster" -nt "$video" ]; then
    continue
  fi

  # Seek a quarter of the way in: past any fade-in, and still inside the clip
  # however short it is.
  duration="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$video")"
  seek="$(awk -v d="$duration" 'BEGIN { printf "%.2f", (d > 0 ? d : 0) / 4 }')"

  # -nostdin: stdin is the find pipe, and ffmpeg would eat the next filename.
  ffmpeg -nostdin -v error -y -ss "$seek" -i "$video" -frames:v 1 \
    -vf "scale='min(720,iw)':-2" "$TMP_DIR/poster.png"
  cwebp -quiet -q 80 "$TMP_DIR/poster.png" -o "$poster"

  echo "$poster"
done
