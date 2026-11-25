// Logitech diNovo Edge — OEM-style 3D-printable charging cradle
// Slotted monolith (tall rear wall + short front lip), pogo pins, USB-C / TP4056 bay.
//
// Calibrate CONTACT_* and CUTOUT_* before final print.
// Export: ./scripts/export-stl.sh

PART = "assembly"; // assembly | cradle | electronics_cover

/* --- Keyboard reference --- */
KB_WIDTH         = 409;
KB_DEPTH         = 211;
KB_THICKNESS     = 12;
CUTOUT_W         = 101.6;
CUTOUT_D         = 38.1;

/* --- OEM outer proportions (match factory stand ~6 in wide) --- */
OEM_WIDTH        = 158;
OEM_BASE_D       = 88;           // main footprint front-to-back
OEM_REAR_EXT     = 14;           // base overhang behind rear wall
OEM_FOOT_H       = 11;           // solid pedestal before slot floor
OEM_REAR_H       = 132;          // tall rear wall
OEM_FRONT_H      = 44;           // short front retaining lip
OEM_WALL_TH      = 8;
OEM_SHELL_TH     = 6;            // side cheek thickness
OEM_FILLET       = 3.5;
LEAN_ANGLE       = 9;            // OEM slot lean (degrees from vertical)
SLOT_CLEAR_Y     = 1.4;          // each side of keyboard thickness (front↔back gap)

/* --- Cutout / fold engagement (anti-slide) --- */
LIP_WIDTH_CLEAR  = 0.5;
LIP_DEPTH_CLEAR  = 0.8;
LIP_WIDTH        = CUTOUT_W - LIP_WIDTH_CLEAR;
LIP_DEPTH        = CUTOUT_D - LIP_DEPTH_CLEAR;
FOLD_STEP_H      = 9.5;
HOOK_H           = 3.0;
HOOK_INSET       = 1.0;

/* --- Pogo pins on fold front face --- */
PIN_COUNT        = 2;
PIN_DIAM         = 1.75;
PIN_HOLE_D       = PIN_DIAM + 0.35;
PIN_BOSS_OD      = 7;
PIN_BOSS_H       = 8;
CONTACT_SPACING  = 19.0;         // MEASURE
CONTACT_HEIGHT   = 6.5;          // MEASURE
CONTACT_INSET    = 2.0;

/* --- TP4056 USB-C bay (underside of rear foot) --- */
TP4056_L         = 30;
TP4056_W         = 22;
TP4056_H         = 12;
USB_PORT_SLOT_W  = 11.5;
USB_PORT_SLOT_H  = 4.5;
ELEC_Y           = -OEM_BASE_D / 2 - OEM_REAR_EXT / 2 + 6;

$fn = 48;

module rounded_prism(sz, r) {
  minkowski() {
    cube([sz[0] - 2 * r, sz[1] - 2 * r, sz[2] - 2 * r], center = true);
    sphere(r = r, $fn = 24);
  }
}

module pin_boss(ix) {
  x = (ix == 0 ? -1 : 1) * CONTACT_SPACING / 2;
  translate([x, 0, CONTACT_HEIGHT])
    difference() {
      cylinder(h = PIN_BOSS_H, d = PIN_BOSS_OD, center = false);
      translate([0, 0, -0.5])
        cylinder(h = PIN_BOSS_H + 2, d = PIN_HOLE_D, center = false);
    }
}

module contact_fold(y0, z0) {
  translate([0, y0, z0]) {
    // Central OEM fold tab in keyboard underside cutout
    rounded_prism([LIP_WIDTH, LIP_DEPTH, FOLD_STEP_H], 1.2);

    if (HOOK_INSET > 0)
      translate([0, -LIP_DEPTH / 2 + HOOK_INSET, FOLD_STEP_H / 2])
        rounded_prism([LIP_WIDTH - 2, LIP_WIDTH * 0.22, HOOK_H], 0.6);

  for (i = [0 : PIN_COUNT - 1])
      translate([0, -LIP_DEPTH / 2 + CONTACT_INSET, 0])
        pin_boss(i);
  }
}

module electronics_cavity() {
  translate([0, ELEC_Y, OEM_FOOT_H / 2 - 2])
    cube([TP4056_L + 4, TP4056_W + 4, TP4056_H + 4], center = true);
}

module usb_c_slot() {
  translate([OEM_WIDTH / 2 - 6, ELEC_Y - TP4056_W / 2 - 2, OEM_FOOT_H / 2])
    rotate([0, 90, 0])
      cube([USB_PORT_SLOT_H, USB_PORT_SLOT_W, OEM_SHELL_TH + 6], center = true);
}

module wire_channel(z0) {
  translate([0, ELEC_Y + 10, (OEM_FOOT_H + z0) / 2])
    cube([5, 28, 22], center = true);
}

// Outer skin: wide foot, tall rear slab, low front prow, solid cheeks
module oem_outer_solid() {
  rear_y = -OEM_BASE_D / 2 - OEM_REAR_EXT / 2;
  front_y = OEM_BASE_D / 2 - 4;

  union() {
    // Pedestal / rear overhang foot (OEM base extends behind stand)
    translate([0, rear_y / 2, OEM_FOOT_H / 2])
      rounded_prism([OEM_WIDTH, OEM_BASE_D + OEM_REAR_EXT, OEM_FOOT_H], OEM_FILLET);

    // Tall rear wall
    translate([0, -OEM_BASE_D / 2 - 2, OEM_FOOT_H + OEM_REAR_H / 2])
      rounded_prism([OEM_WIDTH, OEM_WALL_TH + 2, OEM_REAR_H], OEM_FILLET / 1.5);

    // Short front wall / lip
    translate([0, front_y, OEM_FOOT_H + OEM_FRONT_H / 2])
      rounded_prism([OEM_WIDTH, OEM_WALL_TH + 2, OEM_FRONT_H], OEM_FILLET / 1.5);

    // Front prow (curved OEM nose — simplified as tilted cap)
    translate([0, OEM_BASE_D / 2 + 3, OEM_FOOT_H + OEM_FRONT_H * 0.55])
      rotate([-LEAN_ANGLE, 0, 0])
        rounded_prism([OEM_WIDTH - 18, 7, OEM_FRONT_H + 6], 2);

    // Side cheeks (sculpted sides of the slot)
    for (sx = [-1, 1])
      translate([sx * (OEM_WIDTH / 2 - OEM_SHELL_TH / 2), 2, OEM_FOOT_H + (OEM_REAR_H + OEM_FRONT_H) / 4])
        rounded_prism([OEM_SHELL_TH, OEM_BASE_D - 10, OEM_REAR_H * 0.72], 2);

    // Top bridges left/right (open center slot for keyboard)
    for (sx = [-1, 1])
      translate([sx * (OEM_WIDTH / 2 - OEM_SHELL_TH * 1.1), 2, OEM_FOOT_H + OEM_REAR_H - 9])
        rounded_prism([OEM_SHELL_TH + 2, OEM_BASE_D - 8, 18], 1.5);
  }
}

module keyboard_slot_cut() {
  slot_y = KB_THICKNESS + 2 * SLOT_CLEAR_Y; // thin gap between front lip and rear wall
  slot_top = OEM_FOOT_H + OEM_REAR_H + 25;
  pivot_y = -OEM_BASE_D / 2 + 6;

  translate([0, pivot_y, OEM_FOOT_H + OEM_REAR_H / 2])
    rotate([-LEAN_ANGLE, 0, 0])
      cube([OEM_WIDTH - 2 * OEM_SHELL_TH + 4, slot_y + 0.5, slot_top], center = true);
}

module cradle_body() {
  fold_y = OEM_BASE_D / 2 - LIP_DEPTH / 2 - 6;
  fold_z = OEM_FOOT_H;

  difference() {
    oem_outer_solid();
    keyboard_slot_cut();
    electronics_cavity();
    usb_c_slot();
    wire_channel(fold_z + FOLD_STEP_H);
  }

  contact_fold(fold_y, fold_z);
}

module electronics_cover() {
  difference() {
    translate([0, ELEC_Y, 3])
      rounded_prism([TP4056_L + 8, TP4056_W + 8, 6], 1.2);
    translate([0, ELEC_Y, 4])
      cube([TP4056_L + 2, TP4056_W + 2, 8], center = true);
  }
}

module ghost_keyboard() {
  pivot_y = -OEM_BASE_D / 2 + 6;
  kb_z = OEM_FOOT_H + OEM_REAR_H / 2 + KB_DEPTH / 2 * cos(LEAN_ANGLE);
  kb_y = pivot_y - KB_DEPTH / 2 * sin(LEAN_ANGLE) + 8;

  %translate([0, kb_y, kb_z])
    rotate([-LEAN_ANGLE, 0, 0])
      cube([KB_WIDTH, KB_THICKNESS, KB_DEPTH], center = true);
}

module assembly() {
  color("DimGray", 0.92) cradle_body();
  ghost_keyboard();
}

if (PART == "cradle") {
  cradle_body();
} else if (PART == "electronics_cover") {
  electronics_cover();
} else if (PART == "base" || PART == "back") {
  // Legacy export names → single OEM body
  cradle_body();
} else {
  assembly();
}