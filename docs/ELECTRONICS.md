# Electronics

## What the keyboard expects

The original adapter is **8 V DC, 500 mA**. The two pads in the bottom-centre recess are the dock input. The charging circuit is inside the keyboard and is built for that dock voltage.

A TP4056 charges one bare lithium cell and finishes at **4.2 V**. Those battery terminals are not a substitute for the 8 V dock. Do not tie `B+` / `B−` to the pogo pins unless you have already confirmed that your keyboard charges from that voltage.

## Board the cradle is drawn around

| Item | Default |
|------|---------|
| PCB | 38 × 22 × 1.6 mm, USB-C on a short edge |
| Mounting holes | 4 × M2, centres 3 mm in from each edge (32 × 16 mm) |
| Cradle opening | 13.5 mm wide × 7.4 mm tall, rear face of the foot |
| Screws | M2 × 6 mm, self-tapped into the cover bosses |

Change `BOARD_L`, `BOARD_W`, `HOLE_INSET_L`, `HOLE_INSET_W`, `USB_HOLE_W`, and `USB_HOLE_H` if your module differs, then re-export the STL.

## Using the TP4056 with an 8 V dock input

A practical path that still uses the USB-C socket on the TP4056 board:

```
USB-C 5 V
    │
    ├─ TP4056 module, mounted on the cover (USB-C through the rear hole)
    │     take 5 V from the board's input pads, not from B+
    │
    └─ small boost set to 8.0–8.2 V ── pogo + / pogo −
```

There is about 18 mm of free bay in front of the default board for wires. A boost module that does not fit there can sit beside the cradle; lengthen `POCKET_FRONT` if you want it inside.

Check polarity on the keyboard pads before soldering. With the keyboard out, the open-circuit voltage at the pins should be about 8 V, and the pins should compress a millimetre or two when the keyboard is seated.

## Parts

| Qty | Part |
|-----|------|
| 2 | Pogo pin, 1.5 mm sleeve, solder tail |
| 1 | USB-C TP4056 module, 38 × 22 mm, four M2 holes |
| 4 | M2 × 6 mm screw (board to cover) |
| 4 | M2 × 8 mm screw (cover to foot) |
| 1 | 5 V to 8 V boost, if you are matching the factory dock |
| 1 | USB-C supply, 1 A or more |
| — | 26 AWG wire |
