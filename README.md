# Logitech diNovo Edge — 3D-printable USB-C charging cradle

Open-source mechanical design for a replacement charging stand with **spring pogo pins** aligned to the keyboard’s dock contacts, a **USB-C** access slot, and a cavity for a **TP4056-class** charging board (with documented power architecture).

## What you get

| Path | Purpose |
|------|---------|
| [`openscad/dinovo_cradle.scad`](openscad/dinovo_cradle.scad) | Parametric CAD — lip, pins, electronics bay |
| [`stl/`](stl/) | Pre-exported STLs (`base`, `back`, `electronics_cover`) |
| [`docs/CALIBRATION.md`](docs/CALIBRATION.md) | How to measure contacts and tune OpenSCAD |
| [`docs/ELECTRONICS.md`](docs/ELECTRONICS.md) | USB-C, TP4056 bay, **8 V boost** to pogo pins |
| [`docs/PRINTING.md`](docs/PRINTING.md) | Slicer settings and build order |
| [`bom.csv`](bom.csv) | Parts list |

## Design overview

The OEM stand is only about **6 in / 158 mm** wide; the keyboard rests on a **bottom-center cutout** (~102 × 38 mm) while leaning on a clear back rest. **Weight must hang on the cutout lip + front hook**, not on friction against the back — the tab fills ~37 mm of the recess so it does not slide along the lean. This replica follows that layout so it prints on typical beds without splitting the full **409 mm** keyboard width.

```mermaid
flowchart TB
  subgraph mech [Mechanical]
    KB[diNovo Edge keyboard]
    LIP[Printed lip in underside cutout]
    PIN[Pogo pins on ramp face]
    KB --> LIP
    LIP --> PIN
  end
  subgraph elec [Electronics bay under base]
    USB[USB-C TP4056 board slot]
    BST[5V to 8V boost]
    USB --> BST
    BST --> PIN
  end
```

**Important:** The factory dock supplies **8 V, 500 mA**, not 4.2 V. Reserve the TP4056 for USB-C breakout / 5 V distribution and use a small boost converter to the pogo pins (see [ELECTRONICS.md](docs/ELECTRONICS.md)).

## Quick start

```bash
# Regenerate STLs after editing parameters
./scripts/export-stl.sh
```

1. Read [CALIBRATION.md](docs/CALIBRATION.md) and measure your keyboard.
2. Edit `CONTACT_SPACING`, `CONTACT_HEIGHT`, and lip dimensions in `openscad/dinovo_cradle.scad`.
3. Print `stl/dinovo_cradle_base.stl` and dry-fit before printing the back panel.
4. Wire per [ELECTRONICS.md](docs/ELECTRONICS.md); verify **8 V** at pins before mating the keyboard.

## OpenSCAD parts

Pass `-D 'PART="..."'` when exporting:

- `base` — main dock with pins and cavity  
- `back` — rear support  
- `electronics_cover` — bay lid  
- `assembly` — full preview with ghost keyboard (default)

## License

Hardware and documentation in this repository are provided as-is for personal use. Logitech and diNovo are trademarks of their respective owners.