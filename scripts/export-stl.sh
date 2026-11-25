#!/usr/bin/env bash
# Export the cradle and the TP4056 cover, then write binary STL.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/openscad/dinovo_cradle.scad"
OUT="$ROOT/stl"
mkdir -p "$OUT"

export_one() {
  local part="$1" dest="$2"
  local tmp
  tmp="$(mktemp --suffix=.stl)"
  echo "Exporting $part..."
  openscad -D "PART=\"$part\"" -o "$tmp" "$SCAD"
  python3 "$ROOT/scripts/stl-binary.py" "$tmp" "$dest"
  rm -f "$tmp"
}

export_one cradle "$OUT/dinovo_cradle.stl"
export_one cover "$OUT/dinovo_cradle_cover.stl"
echo "Done. STL files in $OUT"
