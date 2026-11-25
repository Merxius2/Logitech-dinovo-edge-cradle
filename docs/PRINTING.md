# 3D printing notes

## Parts

| STL | Role | Approx. size (mm) |
|-----|------|-------------------|
| `dinovo_cradle_base.stl` | Lip, pogo bosses, electronics cavity, USB slot | 158 × 92 × 26 |
| `dinovo_cradle_back.stl` | Leaned back rest + side guides | 158 × 190 × 40 |
| `dinovo_cradle_electronics_cover.stl` | Snap-over bay cover | 38 × 30 × 10 |

All parts fit a **220 × 220 mm** bed when laid flat.

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

## Assembly to print

1. Print **base** only → calibrate pins ([CALIBRATION.md](CALIBRATION.md)).
2. Print **back** and attach to base with epoxy or M3 screws through the foot block.
3. Print **cover** after electronics fit check.