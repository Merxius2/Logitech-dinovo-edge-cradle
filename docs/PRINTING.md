# 3D printing notes

## Parts

| STL | Role | Approx. size (mm) |
|-----|------|-------------------|
| `dinovo_cradle_cradle.stl` | **OEM-style monolith** — tall rear, front lip, slot, fold, pins | 158 × 102 × 145 |
| `dinovo_cradle_electronics_cover.stl` | Underside bay cover (rear foot) | 38 × 30 × 10 |

`dinovo_cradle_base.stl` / `dinovo_cradle_back.stl` are copies of the monolith for old slicer presets.

Lay the **cradle on its back** (rear wall on the bed) or **feet-down** if your slicer handles the rear overhang; add supports inside the keyboard slot on first print.

## Settings (starting point)

- Material: PETG or ABS (less brittle than PLA for lip tabs; PLA OK for prototypes)
- Layer height: 0.2 mm
- Perimeters: 4
- Infill: 25–35 % gyroid on base; 15 % on back
- Brim: 5 mm on base (large footprint, corners can lift)
- Orientation: as exported (base flat on bed, back with largest face down)

## Post-processing

1. Clear support from USB slot and electronics cavity if any.
2. Run a **1.75 mm drill** by hand through pogo pin holes if needed.
3. Counter-sink M3 holes in back panel foot by hand if using screws.

## What to print (unique parts: **2**)

| # | File | Qty | Notes |
|---|------|-----|--------|
| 1 | `stl/dinovo_cradle_cradle.stl` | **1×** | Full stand — only mandatory print |
| 2 | `stl/dinovo_cradle_electronics_cover.stl` | **1×** | Optional lid over TP4056 bay under rear foot |

Do **not** print `dinovo_cradle_base.stl` and `dinovo_cradle_back.stl` **in addition** to `cradle.stl` — they are identical copies of the monolith for older filenames.

## Suggested print order

1. Print **cradle** → dry-fit keyboard ([CALIBRATION.md](CALIBRATION.md)).
2. Install pogo pins + electronics; verify fit.
3. Print **electronics_cover** if the bay needs a lid.