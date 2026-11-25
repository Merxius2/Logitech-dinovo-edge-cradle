#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/openscad/dinovo_cradle.scad"
OUT="$ROOT/stl"
mkdir -p "$OUT"

PARTS=(side_left side_right center cradle electronics_cover)
for part in "${PARTS[@]}"; do
  echo "Exporting $part..."
  openscad -D "PART=\"$part\"" -o "$OUT/dinovo_cradle_${part}.stl" "$SCAD"
done

cp "$OUT/dinovo_cradle_cradle.stl" "$OUT/dinovo_cradle_base.stl"
cp "$OUT/dinovo_cradle_cradle.stl" "$OUT/dinovo_cradle_back.stl"

echo "Done. STL files in $OUT"