# 3D printing notes

## What to print

### Split build (recommended on tight beds)

| # | STL | Qty | Max bbox (mm) | Bed note |
|---|-----|-----|---------------|----------|
| 1 | `dinovo_cradle_side_left.stl` | 1 | ~22 × 102 × 145 | Small — any bed |
| 2 | `dinovo_cradle_side_right.stl` | 1 | ~22 × 102 × 145 | Mirror of left |
| 3 | `dinovo_cradle_center.stl` | 1 | ~118 × 102 × 145 | Fits 220 × 220 |
| 4 | `dinovo_cradle_electronics_cover.stl` | 1 | ~38 × 30 × 6 | Optional |

Assembly: [ASSEMBLY.md](ASSEMBLY.md).

### One-piece build

| STL | Qty |
|-----|-----|
| `dinovo_cradle_cradle.stl` | 1 (full monolith) |

`dinovo_cradle_base.stl` / `dinovo_cradle_back.stl` duplicate `cradle.stl` — do not print extras.

## Orientation

| Part | On bed |
|------|--------|
| **Sides** | Largest flat face down (inner seam facing up) |
| **Center** | **Rear wall down** or foot down; supports in slot if needed |
| **Cover** | Flat |

## Settings (starting point)

- Material: PETG or ABS on center/sides; PLA OK for prototypes
- Layer height: 0.2 mm, 4 perimeters, 25–35 % gyroid
- Brim on **center** (and on full cradle)

## Post-processing

1. Ream pogo pin holes with 1.75 mm drill if needed.
2. Lightly sand peg faces on center if sides are hard to press on.
3. Clear USB slot burrs after printing center/cradle.