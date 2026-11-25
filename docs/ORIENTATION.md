# Model orientation (for previews and OpenSCAD)

When the cradle sits on a desk ready to receive the keyboard:

| Direction | OpenSCAD axis | What you see |
|-----------|---------------|--------------|
| **Front** | +Y | Short lip, slot opening, prow (OEM “logitech” face) |
| **Back** | −Y | Tall rear wall + foot overhang; USB cavity is under here |
| **Width** | X | ~158 mm left–right (stand width) |
| **Up** | +Z | Keyboard stands upright in the slot |

The factory product photo is roughly a **front-right isometric** (camera from +X, +Y, +Z).

OpenSCAD PNG example matching that photo:

```bash
openscad -D 'PART="cradle"' --imgsize=1200,900 \
  --camera=0,-0.72,0.52,62,0,25,750 \
  -o front.png openscad/dinovo_cradle.scad
```

**Back view** (tall slab, foot trailing away):

```bash
openscad -D 'PART="cradle"' --imgsize=1200,900 \
  --camera=0,0.75,0.48,62,0,205,750 \
  -o back.png openscad/dinovo_cradle.scad
```

The fold and pogo pins sit **inside the slot floor** near +Y; they are visible in a low front or isometric view, not on the flat exterior of the rear wall.