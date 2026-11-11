#!/usr/bin/env bash
# Generate the slide cover illustrations from course/slides/img/prompts.tsv.
#
#   scripts/slide_images.sh agy   [name]   # Antigravity CLI (Gemini image tool)
#   scripts/slide_images.sh codex [name]   # Codex CLI (image_generation feature)
#
# Each prompt asks for a 16:9 picture with no text (generated text is often
# misspelled; slide titles are HTML). Output: course/slides/img/<name>.png,
# then convert it to the committed JPG, e.g. on macOS:
#   sips -s format jpeg -s formatOptions 82 --resampleWidth 1280 x.png --out x.jpg
# Both CLIs need their own login and spend your plan's quota.
set -euo pipefail
tool=${1:?usage: slide_images.sh agy|codex [name]}
only=${2:-}
dir=$(cd "$(dirname "$0")/../course/slides/img" && pwd)
style="Style: flat isometric vector illustration, dark navy background #2D2D64, gold accents #F3A63D, white line art, clean, modern, educational, consistent series. ABSOLUTELY NO TEXT, letters, words, numbers or logos anywhere in the image. Reply only with the saved file path."
cd "$dir"
while IFS=$'\t' read -r name subject; do
  [ -n "$only" ] && [ "$name" != "$only" ] && continue
  prompt="Use your image generation tool to create ONE illustration and save it in this directory as $name.png, landscape 16:9. Subject: $subject $style"
  case "$tool" in
    agy) agy --dangerously-skip-permissions --print-timeout 540s -p "$prompt" </dev/null ;;
    codex) codex exec -s workspace-write --skip-git-repo-check "$prompt" </dev/null ;;
    *) echo "unknown tool: $tool" >&2; exit 2 ;;
  esac
  [ -f "$name.png" ] && echo "ok $name.png" || echo "FAILED $name" >&2
done < prompts.tsv
