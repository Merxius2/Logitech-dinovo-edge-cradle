# Calibrating pogo pin alignment

Published specs do not include contact pitch. **Measure your keyboard** before the final print.

## Tools

- Digital calipers
- Masking tape on contacts (optional, to see witness marks)
- Original dock (if available) for reference

## Steps

1. **Cutout** — Measure the width and depth of the bottom-center underside recess. Defaults in OpenSCAD: 101.6 × 38.1 mm (`CUTOUT_W`, `CUTOUT_D`). Adjust `LIP_WIDTH` / `LIP_DEPTH` if needed (add ~0.6–1.0 mm clearance each axis).

2. **Contact spacing** — Measure center-to-center between the two copper pads on the **vertical step** of the rear ramp. Edit `CONTACT_SPACING` in `openscad/dinovo_cradle.scad`.

3. **Contact height** — With the keyboard resting as in the OEM stand (or balanced on blocks at the same lean), measure from the **top of the ramp step** (the horizontal shelf under the contacts) up to the center of each pad. Edit `CONTACT_HEIGHT`.

4. **Pin protrusion** — Start with `CONTACT_INSET = 2.0` mm. After a test print, pins should protrude ~1.5–2.5 mm beyond the printed face and compress slightly when the keyboard is fully seated in the lip.

5. **Dry fit** — Print only `PART="base"` first. Slide the keyboard into the lip cutout without power. Contacts should line up visually; use carbon paper or a felt marker on pads to mark witness dots on the pins.

6. **OpenSCAD preview** — Open `dinovo_cradle.scad`, set `PART = "assembly"`, and use the ghost keyboard (`%` module) to check lean and lip engagement.

## Parameter cheat sheet

| Variable | Meaning |
|----------|---------|
| `CONTACT_SPACING` | Horizontal distance between pogo pin centers |
| `CONTACT_HEIGHT` | Vertical offset of pin centers on lip face |
| `CONTACT_INSET` | How far pins extend toward keyboard |
| `LIP_WIDTH` / `LIP_DEPTH` | Mechanical fit in underside cutout |
| `LEAN_ANGLE` | Back panel tilt — match OEM feel (~10–15°) |

Community reference values (unverified — use as starting point only): spacing ~18–20 mm, contact centers a few mm above the step lip.