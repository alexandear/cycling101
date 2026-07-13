#!/bin/sh
set -e

if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "Error: yt-dlp is not installed" >&2
  echo "Install it from https://github.com/yt-dlp/yt-dlp#installation" >&2
  exit 1
fi

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 <youtube-url> <section> [output-file]" >&2
  echo "Example: $0 'https://youtu.be/jwk9M4xmIdg?si=i6OjtxRG_PsWWIl9' '*17:35-17:45' out.mp4" >&2
  exit 1
fi

URL="$1"
SECTION="$2"
OUTPUT="${3:-out.mp4}"

VIDEO_DIR="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)/videos"
mkdir -p "$VIDEO_DIR"

yt-dlp \
  -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" \
  --download-sections "$SECTION" \
  --postprocessor-args "ffmpeg:-crf 18 -preset fast" \
  -o "$VIDEO_DIR/$OUTPUT" \
  "$URL"
