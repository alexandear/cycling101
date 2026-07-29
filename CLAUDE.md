# CLAUDE.md

## Project

Static single-page website for a beginner cycling training series ("Тренування для
початківців — Підготовка до Київської Сотки"). Content is in Ukrainian. Deployed at
https://cycling101.pp.ua/.

## Structure

- `index.html` — the entire site: one page with inline `<style>` and inline `<script>`.
  Page content (lessons, articles, participants) is rendered from JS data objects in
  the script. No build step, no framework, no dependencies.
- `images/` — photos and charts. Each source (`.jpg`/`.png`) has a `.webp` sibling.
- `videos/` — local video clips, git-ignored (see `.gitignore`).
- `scripts/` — helper shell scripts (not part of the deployed site).
- `favicon.*`, `apple-touch-icon.png`, `og-image.png` — icons and social share image.
- `.assetsignore` — allow-list of files served by the host; keep it in sync with the
  actual site assets.

## Run locally

```sh
python3 -m http.server 8000 --directory .
```

Then open http://localhost:8000.

## Working conventions

- Edit content and layout directly in `index.html`; there is no compilation.
- Add images to `images/` and generate `.webp` versions with
  `scripts/convert-to-webp.sh` (requires `cwebp`).
- Download video clips with `scripts/download-video.sh` (requires `yt-dlp`).
- Keep the HTML strict semantic HTML5.
- When adding or removing top-level site assets, update `.assetsignore` accordingly.
