#!/usr/bin/env bash
set -euo pipefail
OLD_TEX=${1:-0311.tex}
NEW_TEX=${2:-main.tex}
OUT_TEX=${3:-diff.tex}
if ! command -v latexdiff >/dev/null 2>&1; then
  echo "latexdiff not found" >&2
  exit 1
fi
if ! command -v latexmk >/dev/null 2>&1; then
  echo "latexmk not found" >&2
  exit 1
fi
echo "Generating diff: ${OLD_TEX} -> ${NEW_TEX} -> ${OUT_TEX}"
latexdiff --exclude-textcmd=cmidrule --exclude-textcmd=multicolumn --exclude-textcmd=multirow "${OLD_TEX}" "${NEW_TEX}" > "${OUT_TEX}"
perl -0777 -pe 's/\\cmidrule\s*\\DIFaddFL\{\(lr\)\}\{\\DIFaddFL\{([0-9]+-[0-9]+)\}\}/\\cmidrule(lr){$1}/g' -i "${OUT_TEX}"
echo "Compiling ${OUT_TEX}"
latexmk -C "${OUT_TEX}" || true
latexmk -pdf -interaction=nonstopmode -file-line-error -time -f -gg "${OUT_TEX}"
echo "Done: ${OUT_TEX%.tex}.pdf"
