#!/bin/sh
set -e

# Re-encodes phone exports in videos/ into something every browser can play:
# H.264 (Safari plays HEVC, Chrome and Firefox usually do not), long side capped
# at 1280, and the moov atom up front so playback starts before the full
# download. Files that already match are left alone, so re-running is safe and
# never recompresses the same clip twice. Pass -f to recompress them anyway,
# for a clip that plays fine but is still heavier than it needs to be.

LONG_SIDE=1280
CRF=26

FORCE=0
if [ "$1" = "-f" ]; then
  FORCE=1
fi

if ! command -v ffmpeg >/dev/null 2>&1 || ! command -v ffprobe >/dev/null 2>&1; then
  echo "Error: ffmpeg is not installed" >&2
  echo "Install it from https://ffmpeg.org/download.html" >&2
  exit 1
fi

VIDEO_DIR="$(CDPATH= cd -- "$(dirname "$0")/../videos" && pwd)"

# csv=p=0 appends a trailing comma, which would break the numeric tests below.
probe() {
  ffprobe -v error -select_streams v:0 -show_entries "stream=$1" \
    -of default=noprint_wrappers=1:nokey=1 "$2"
}

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Recursive: videos/ has per-section subfolders (videos/blog, ...).
find "$VIDEO_DIR" -type f \
  \( -iname '*.mp4' -o -iname '*.mov' -o -iname '*.m4v' \) |
while read -r video; do
  codec="$(probe codec_name "$video")"
  width="$(probe width "$video")"
  height="$(probe height "$video")"

  long="$width"
  if [ "$height" -gt "$long" ]; then
    long="$height"
  fi

  if [ "$FORCE" -eq 0 ] && [ "$codec" = "h264" ] && [ "$long" -le "$LONG_SIDE" ]; then
    continue
  fi

  out="$TMP_DIR/$(basename "${video%.*}").mp4"
  # -nostdin: stdin is the find pipe, and ffmpeg would eat the next filename.
  ffmpeg -nostdin -v error -y -i "$video" \
    -vf "scale='if(gte(iw,ih),min($LONG_SIDE,iw),-2)':'if(gte(iw,ih),-2,min($LONG_SIDE,ih))'" \
    -c:v libx264 -profile:v high -crf "$CRF" -preset slow -pix_fmt yuv420p \
    -c:a aac -b:a 128k \
    -movflags +faststart "$out"

  before="$(wc -c <"$video" | tr -d ' ')"
  after="$(wc -c <"$out" | tr -d ' ')"

  # The source extension may differ from .mp4, so drop it after the move.
  mv "$out" "${video%.*}.mp4"
  [ "$video" = "${video%.*}.mp4" ] || rm -f "$video"

  echo "${video%.*}.mp4: $codec ${width}x${height} ${before}B -> h264 ${after}B"
done
