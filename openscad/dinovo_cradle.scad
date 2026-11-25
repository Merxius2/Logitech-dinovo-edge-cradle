// Logitech diNovo Edge — 3D-printable charging cradle
// Parametric layout: narrow center dock (~original OEM width), pogo pins, USB-C / TP4056 bay.
//
// Calibrate CONTACT_* and LIP_* against your keyboard before committing to a long print.
// Export: openscad -D 'PART="base"' -o stl/base.stl openscad/dinovo_cradle.scad

PART = "assembly"; // assembly | base | back | pin_plate | electronics_cover

/* --- Keyboard reference (Logitech specs + community measurements) --- */
KB_WIDTH         = 409;   // mm
KB_DEPTH         = 211;
KB_THICKNESS     = 12;
CUTOUT_W         = 101.6; // ~4 in bottom-center recess on keyboard underside
CUTOUT_D         = 38.1;  // ~1.5 in

/* --- Dock geometry (OEM stand is ~6 in wide, not full keyboard width) --- */
STAND_WIDTH      = 158;   // mm printable base width
BASE_DEPTH       = 92;
BASE_FOOT_H      = 4;
ELECTRONICS_H    = 18;    // cavity height under pin area (TP4056 + wiring)
BACK_H           = 188;   // back rest height
BACK_TH          = 6;
LEAN_ANGLE       = 12;    // degrees from vertical (keyboard leans slightly back)

/* --- Bottom lip engaging CUTOUT --- */
LIP_WIDTH        = CUTOUT_W + 1.2;  // slight clearance
LIP_DEPTH        = 14;              // protrusion into cutout
LIP_STEP_H       = 10;              // vertical face where contacts live (tune)

/* --- Pogo pins (P75-B1 / similar 1.5–1.7 mm barrel, ~2 mm nose) --- */
PIN_COUNT        = 2;
PIN_DIAM         = 1.75;
PIN_HOLE_D       = PIN_DIAM + 0.35;
PIN_BOSS_OD      = 7;
PIN_BOSS_H       = 8;
// Position on the lip vertical face (origin: center of lip, bottom of lip step)
CONTACT_SPACING  = 19.0;   // center-to-center — MEASURE your keyboard
CONTACT_HEIGHT   = 6.5;    // from top of lip step to contact center — MEASURE
CONTACT_INSET    = 2.0;    // from front face of lip (pins stick out this far)

/* --- TP4056-class USB-C module bay (typical 27×19 mm PCB) --- */
TP4056_L         = 30;
TP4056_W         = 22;
TP4056_H         = 12;
USB_PORT_SLOT_W  = 11.5;
USB_PORT_SLOT_H  = 4.5;
USB_REAR_OFFSET  = 8;

/* --- Print tolerances --- */
TOL              = 0.25;
$fn              = 48;

module rounded_cube(sz, r) {
  minkowski() {
    cube([sz[0] - 2*r, sz[1] - 2*r, sz[2] - 2*r], center = true);
    sphere(r = r);
  }
}

module electronics_cavity() {
  translate([0, BASE_DEPTH/2 - ELECTRONICS_H/2 - 6, BASE_FOOT_H + ELECTRONICS_H/2])
    cube([TP4056_L + 4, TP4056_W + 4, ELECTRONICS_H + 2], center = true);
}

module usb_c_slot() {
  translate([STAND_WIDTH/2 - USB_REAR_OFFSET, BASE_DEPTH - 2, BASE_FOOT_H + 5])
    rotate([90, 0, 90])
      cube([USB_PORT_SLOT_W, USB_PORT_SLOT_H, BACK_TH + 4], center = true);
}

module wire_channel() {
  // Route from electronics bay up to pin bosses
  translate([0, BASE_DEPTH/2 - 20, BASE_FOOT_H + ELECTRONICS_H + 2])
    cube([6, 35, 16], center = true);
}

module pin_boss(ix) {
  x = (ix == 0 ? -1 : 1) * CONTACT_SPACING / 2;
  translate([x, 0, CONTACT_HEIGHT])
    difference() {
      cylinder(h = PIN_BOSS_H, d = PIN_BOSS_OD, center = false);
      translate([0, 0, -0.5])
        cylinder(h = PIN_BOSS_H + 2, d = PIN_HOLE_D, center = false);
      // Chamfer entry from keyboard side
      translate([0, -PIN_BOSS_OD/2 - 0.2, PIN_BOSS_H - 3])
        rotate([45, 0, 0])
          cube([PIN_BOSS_OD, PIN_BOSS_OD, 6], center = true);
    }
}

module lip_and_pins() {
  lip_y = BASE_DEPTH/2 - LIP_DEPTH/2 + 2;
  pin_face_y = lip_y - LIP_DEPTH + CONTACT_INSET;

  difference() {
  union() {
    // Main base slab (electronics below front half)
    translate([0, 0, BASE_FOOT_H])
      cube([STAND_WIDTH, BASE_DEPTH, ELECTRONICS_H], center = true);

    // Lip tab (engages keyboard underside cutout)
    translate([0, lip_y, BASE_FOOT_H + ELECTRONICS_H])
      rounded_cube([LIP_WIDTH, LIP_DEPTH, LIP_STEP_H], 1.5);

    // Ramp transition behind lip (keyboard bottom rear bears here)
    translate([0, lip_y - LIP_DEPTH/2 - 8, BASE_FOOT_H + ELECTRONICS_H + LIP_STEP_H/2])
      scale([1, 1, 0.6])
        rounded_cube([STAND_WIDTH - 10, 22, LIP_STEP_H + 4], 2);

    // Pin bosses on vertical front of lip step
    for (i = [0 : PIN_COUNT - 1])
      translate([0, pin_face_y, BASE_FOOT_H + ELECTRONICS_H])
        pin_boss(i);
  }
    electronics_cavity();
    usb_c_slot();
    wire_channel();
  }
}

module back_panel() {
  angle = LEAN_ANGLE;
  y_off = -BASE_DEPTH/2 + BACK_TH;

  difference() {
    union() {
      translate([0, y_off, BASE_FOOT_H + ELECTRONICS_H + 8])
        rotate([angle, 0, 0])
          translate([0, BACK_H/2, BACK_H/2])
            rounded_cube([STAND_WIDTH, BACK_TH, BACK_H], 2);

      // Foot on base for glue/screw
      translate([0, y_off, BASE_FOOT_H + ELECTRONICS_H + 6])
        cube([STAND_WIDTH - 30, BACK_TH + 6, 8], center = true);

      // Two side hooks to keep keyboard centered on narrow stand
      for (sx = [-1, 1])
        translate([sx * (STAND_WIDTH/2 - 4), BASE_DEPTH/2 - 20, BASE_FOOT_H + ELECTRONICS_H + 35])
          rotate([angle, 0, 0])
            cube([6, BACK_TH + 2, 55], center = true);
    }
    // Lightening
    translate([0, y_off - 2, BASE_FOOT_H + ELECTRONICS_H + BACK_H/2])
      rotate([angle, 0, 0])
        cube([STAND_WIDTH - 40, BACK_TH + 4, BACK_H - 40], center = true);
  }
}

module electronics_cover() {
  difference() {
    translate([0, BASE_DEPTH/2 - ELECTRONICS_H/2 - 6, BASE_FOOT_H + ELECTRONICS_H/2])
      rounded_cube([TP4056_L + 8, TP4056_W + 8, ELECTRONICS_H - 2], 1.2);
    translate([0, BASE_DEPTH/2 - ELECTRONICS_H/2 - 6, BASE_FOOT_H + ELECTRONICS_H/2 + 1])
      cube([TP4056_L + 2, TP4056_W + 2, ELECTRONICS_H + 2], center = true);
    // Screw bosses
    for (dx = [-1, 1], dy = [-1, 1])
      translate([dx * (STAND_WIDTH/2 - 18), BASE_DEPTH/2 - 28 + dy * 8, BASE_FOOT_H + 2])
        cylinder(h = 6, d = 3.2, $fn = 24);
  }
}

module ghost_keyboard() {
  // Flat keyboard: width × depth × thickness (X × Y × Z), then stand upright and lean back.
  tilt = 90 - LEAN_ANGLE;
  lip_top_z = BASE_FOOT_H + ELECTRONICS_H + LIP_STEP_H;
  lip_y = BASE_DEPTH / 2 - LIP_DEPTH / 2 + 2;
  // Vertical half-extent after tipping (corner of depth + thickness axes).
  kb_half_up = KB_DEPTH / 2 * sin(tilt) + KB_THICKNESS / 2 * cos(tilt);
  kb_half_fwd = KB_DEPTH / 2 * cos(tilt) - KB_THICKNESS / 2 * sin(tilt);
  y_center = lip_y - kb_half_fwd * 0.55;
  z_center = lip_top_z + kb_half_up;

  %translate([0, y_center, z_center])
    rotate([tilt, 0, 0])
      cube([KB_WIDTH, KB_DEPTH, KB_THICKNESS], center = true);
}

module assembly() {
  color("Orange") lip_and_pins();
  color("DimGray") back_panel();
  ghost_keyboard();
}

if (PART == "base") {
  lip_and_pins();
} else if (PART == "back") {
  back_panel();
} else if (PART == "pin_plate") {
  for (i = [0 : PIN_COUNT - 1])
    pin_boss(i);
} else if (PART == "electronics_cover") {
  electronics_cover();
} else {
  assembly();
}