# Electronics

The cradle is powered by a **USB-C cable plugged into the TP4056**. You do not need the original Logitech adapter. The cable enters through the hole in the rear of the foot. Two pogo pins in the centre slots touch the keyboard.

```
USB-C cable
    │
    ▼
TP4056 board, screwed to the cover
    │  OUT+ and OUT−  (or B+ and B− if that is all the board labels)
    ▼
wire in the bay
    │
    ▼
pogo pin tails  →  keyboard contacts
```

Solder the wires to the pin tails before you push the pins down the slots. One pin is positive, one is negative. Mark which slot is which.

The original dock was **8 V**. A TP4056’s battery output is **4.2 V**. Wire it as above and try it. If the keyboard does not charge, take **5 V from the board’s input pads** (the USB side, not the battery side) to a small boost set to 8 V, and send that to the pins instead. The bay in front of the board has room for those wires.

## Board the cradle is drawn around

| Item | Default |
|------|---------|
| PCB | 38 × 22 × 1.6 mm, USB-C on a short edge |
| Mounting holes | 4 × M2, centres 3 mm in from each edge (32 × 16 mm) |
| Cradle opening | 13.5 mm wide × 7.4 mm tall, rear face of the foot |
| Screws | M2 × 6 mm, self-tapped into the cover bosses |

Change `BOARD_L`, `BOARD_W`, `HOLE_INSET_L`, `HOLE_INSET_W`, `USB_HOLE_W`, and `USB_HOLE_H` if your module differs, then re-export the STL.

## Pogo pin slots

Each slot is **8 mm long and 2.05 mm wide**, for a **1.5 mm × 16 mm** straight pogo pin. The pin drops in from the top of the centre pad. The bottom of the slot narrows to 1.35 mm, which the sleeve cannot pass, so the pin stops with about **2.6 mm** of tip above the pad. The tail and the wire hang in the bay under that step.

Slide the pin along the slot until the tip meets the keyboard contact, then fix it with a drop of glue if it is loose. If your pins are a different length, change `PIN_LEN`. If the sleeve will not enter, the printed slot is a little tight: open `PIN_SLOT_W` by 0.15 mm.

## Parts

| Qty | Part |
|-----|------|
| 2 | Pogo pin, straight, 1.5 mm × 16 mm |
| 1 | USB-C TP4056 module, 38 × 22 mm, four M2 holes |
| 4 | M2 × 6 mm screw (board to cover) |
| 4 | M2 × 8 mm screw (cover to foot) |
| 1 | 5 V to 8 V boost, if you are matching the factory dock |
| 1 | USB-C supply, 1 A or more |
| — | 26 AWG wire |
