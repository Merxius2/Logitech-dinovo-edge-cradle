# Assembly

1. Measure the keyboard contacts and regenerate the STL if `CONTACT_SPACING` changed. See [CALIBRATION.md](CALIBRATION.md).
2. Solder wires to the pogo tails, then press the pins into the two holes on the centre pad. The sleeves sit in the top 8 mm; the tails drop into the bay.
3. Place the TP4056 on the cover bosses, USB-C toward the rear edge of the cover (the edge that will face the back of the stand). Screw it down with four M2 × 6 mm screws.
4. Drop the cover into the recess in the foot. The receptacle should line up with the rear opening. Fasten the cover with four M2 × 8 mm screws into the side rims.
5. A USB-C plug should pass through the rear hole and seat in the receptacle. If it stops short, increase `USB_PROTRUDE` or `USB_HOLE_W` slightly and reprint, or file the opening.
6. Wire per [ELECTRONICS.md](ELECTRONICS.md). Confirm voltage and polarity at the pins before the keyboard goes in.
7. Set the keyboard into the slot so the bottom cutout drops over the centre pad and the lip stops it sliding forward. It leans back against the tall fin.

![Cover bosses](preview/cover.png)
