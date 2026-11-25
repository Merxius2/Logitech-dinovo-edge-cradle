# Electronics — USB-C power and pogo pins

## What the keyboard expects

The OEM dock adapter is **8 V DC, 500 mA** (Logitech P/N 190601-0000, DVE DSA-5P-08 FUS 080050). The two copper pads on the **vertical face of the bottom rear ramp** are the dock interface; the keyboard’s internal charging circuit is built for that dock voltage, not for a bare 4.2 V Li-ion charger output.

## Recommended power path (keyboard charging)

```
USB-C 5 V (charger or port)
        │
        ▼
  [Boost module, e.g. MT3608 + trim to 8.0–8.2 V]
        │
        ▼
  [Optional 500 mA polyfuse or current-limited supply]
        │
   ┌────┴────┐
   ▼         ▼
 Pogo +   Pogo −
```

**Polarity:** With a multimeter, note which keyboard pad is positive when seated in an original dock (or measure diode orientation on the internal charge path if you have the back off). Wire the pogo pins accordingly and **mark the cradle**.

**TP4056 role:** A standard TP4056 module charges a **standalone** 18650/ pouch cell at **4.2 V**. It does **not** replace the OEM 8 V dock supply for the diNovo Edge contacts. This mechanical design includes a bay sized for a common **USB-C TP4056** board so you can:

1. **Use the bay as a USB-C entry panel** — mount the module only for its USB-C connector and 5 V `IN+` / `IN−`, then route 5 V to an external boost board glued beside the bay (recommended), or  
2. **Repurpose later** — e.g. power a small fan, LED, or auxiliary battery holder without feeding 4.2 V into the keyboard.

Do **not** connect `B+` / `B−` from a TP4056 directly to the keyboard pogo pins unless you have verified the keyboard accepts ~4 V on those pads (most units do not charge from the dock at Li-ion cell voltage).

## Bill of materials

| Qty | Part | Notes |
|-----|------|--------|
| 2 | Spring pogo pin, ~12–16 mm travel (e.g. P75-B1 class) | 1.5 mm probe; solder tail in boss hole |
| 1 | USB-C TP4056 charging board (28 mm type) | Fits electronics cavity |
| 1 | Step-up converter, 5 V → adjustable, set to **8 V** | MT3608 or equivalent |
| 1 | USB-C cable or 5 V PSU | 1 A minimum |
| — | 26 AWG silicone wire, heatshrink, optional 500 mA fuse | Route through wire channel |
| 4 | M3 × 10 mm screws + nuts | Base to back panel (or epoxy) |
| — | Cyanoacrylate / epoxy | Back panel to base if not screwing |

## Assembly

1. Solder wires to pogo pin tails before inserting pins; insert from the boss side so probes face the keyboard.
2. Mount TP4056 in the cavity with the USB-C port aligned to the rear slot; secure with a dab of hot glue or M2 screws into printed bosses.
3. Mount boost converter beside or above the module; connect `IN` from USB 5 V (from TP4056 USB input pads **or** parallel from the same 5 V feed).
4. Route `OUT+` / `OUT−` to pogo pins; strain-relief cables in the wire channel.
5. Snap or screw on `electronics_cover` (printed).
6. Verify **open-circuit** boost voltage is 8.0–8.2 V before first keyboard mate. Fold a paper strip over pins for a dry test.

## Safety

- Unplug USB when unattended.
- If the keyboard charge LED does not go green, stop — check polarity and voltage.
- Mating force is set by spring pins and pin protrusion (`CONTACT_INSET` in OpenSCAD); pins should compress ~1–2 mm when seated.