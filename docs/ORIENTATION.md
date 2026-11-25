# Orientation

The stand sits on the foot. In OpenSCAD:

| Axis | Meaning |
|------|---------|
| +X | Right |
| +Y | Front, the shorter fin |
| −Y | Rear, the tall fin and the USB-C hole |
| +Z | Up |

The factory photo is a front three-quarter view: short fin toward the camera, tall fin behind, slot between them.

```bash
# Side, rear fin on the left
openscad -D 'PART="cradle"' --imgsize=1100,800 \
  --camera=420,0,42,0,0,40 \
  -o side.png openscad/dinovo_cradle.scad

# Rear face, USB-C hole
openscad -D 'PART="cradle"' --imgsize=900,700 \
  --camera=0,-120,12,0,-43,11 \
  -o port.png openscad/dinovo_cradle.scad
```

`PART="assembly"` adds a translucent keyboard leaned back in the slot.
