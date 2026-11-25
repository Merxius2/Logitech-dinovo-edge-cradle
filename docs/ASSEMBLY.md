# Split-print assembly

## Parts (recommended print set)

| STL | Qty | Role |
|-----|-----|------|
| `dinovo_cradle_side_left.stl` | 1 | Left outer cheek / side wall |
| `dinovo_cradle_side_right.stl` | 1 | Right side (mirror) |
| `dinovo_cradle_center.stl` | 1 | Rear wall, front lip, slot floor, **fold + pogo bosses**, joint pegs |
| `dinovo_cradle_electronics_cover.stl` | 1 | Optional underside bay lid |

**`dinovo_cradle_cradle.stl`** is the same geometry **pre-joined** — one piece if you prefer a single print.

## How the split works

```
        [ side_left ]  | [      center      ]  | [ side_right ]
              22 mm    |   ~118 mm           |     22 mm     
```

- **`SIDE_PART_W`** (22 mm): each side STL from the outer edge inward.
- **`JOINT_OVERLAP`** (4 mm): mating flanges with **3× pegs** at Z ≈ 32 / 72 / 112 mm.
- Pins are on **center**; pockets in **sides**.

## Assembly steps

1. Solder pogo pins into **center** before glue-up (easier access).
2. Install TP4056 / wiring in the center cavity; route wires through the channel toward the fold.
3. Dry-fit: slide sides onto center pegs; check keyboard fit.
4. Apply epoxy or gel CA on the mating faces **and** pegs; clamp 15–30 min (or use M3 screws through printed pilot holes if you add them).
5. Optional: snap on `electronics_cover`.

## Alternative: one-piece print

Use only `dinovo_cradle_cradle.stl` when bed size and supports are acceptable (~158 mm wide).

## Tuning

Edit in `openscad/dinovo_cradle.scad`:

- `SIDE_PART_W` — wider sides if you want smaller center or more OEM “wing” material on sides.
- `JOINT_PEG_D` / `JOINT_HOLE_D` — if pegs are too tight, increase hole diameter by 0.2 mm.