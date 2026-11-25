# Calibration

Logitech does not publish the contact pitch. Measure your keyboard, then edit `openscad/dinovo_cradle.scad` and run `./scripts/export-stl.sh`.

| Variable | What to measure |
|----------|-----------------|
| `CONTACT_SPACING` | Centre-to-centre of the two pads. Default 18 mm. |
| `KB_THICK` | Thickness of the edge that sits in the slot. Default 12 mm. Use 19.5 if you measure the thicker body. |
| `CUTOUT_W` | Width of the bottom-centre recess. Default 101.6 mm (4 in). |
| `LEAN` | How far the keyboard leans back from vertical. Default 12°. |
| `BOARD_L`, `BOARD_W` | Your TP4056 outline. Default 38 × 22 mm. |
| `HOLE_INSET_L`, `HOLE_INSET_W` | Distance from each PCB edge to the mounting-hole centres. Default 3 mm. |
| `USB_HOLE_W`, `USB_HOLE_H` | Rear opening. Default 13.5 × 7.4 mm. |
| `USB_Z_ABOVE` | Receptacle centre above the bottom of the PCB. Default 3.4 mm. |
| `PIN_HOLE_D` | Press fit for the pogo sleeve. Default 1.8 mm. |

Dry-fit the cradle with no power. The centre pad should enter the recess, the lip should stop the keyboard sliding out, and the pin holes should land on the pads. A felt marker on the pads leaves a witness mark if you need to shift `CONTACT_SPACING`.
