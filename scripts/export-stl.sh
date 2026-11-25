#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/openscad/dinovo_cradle.scad"
OUT="$ROOT/stl"
mkdir -p "$OUT"

for part in cradle electronics_cover; do
  echo "Exporting $part..."
  openscad -D "PART=\"$part\"" -o "$OUT/dinovo_cradle_${part}.stl" "$SCAD"
done

# Legacy filenames (single OEM body replaces old base+back)
cp "$OUT/dinovo_cradle_cradle.stl" "$OUT/dinovo_cradle_base.stl"
cp "$OUT/dinovo_cradle_cradle.stl" "$OUT/dinovo_cradle_back.stl"

echo "Done. STL files in $OUT"