#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/openscad/dinovo_cradle.scad"
OUT="$ROOT/stl"
mkdir -p "$OUT"

for part in base back electronics_cover; do
  echo "Exporting $part..."
  openscad -D "PART=\"$part\"" -o "$OUT/dinovo_cradle_${part}.stl" "$SCAD"
done

echo "Done. STL files in $OUT"