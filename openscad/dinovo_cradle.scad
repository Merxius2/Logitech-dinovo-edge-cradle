// Logitech diNovo Edge — OEM-style 3D-printable charging cradle
// Printable as monolith OR split: side_left + side_right + center (+ cover)
// Export: ./scripts/export-stl.sh

PART = "assembly";
// assembly | cradle | center | side_left | side_right | electronics_cover | base | back

/* --- Keyboard reference --- */
KB_WIDTH         = 409;
KB_DEPTH         = 211;
KB_THICKNESS     = 12;
CUTOUT_W         = 101.6;
CUTOUT_D         = 38.1;

/* --- OEM outer proportions --- */
OEM_WIDTH        = 158;
OEM_BASE_D       = 88;
OEM_REAR_EXT     = 14;
OEM_FOOT_H       = 11;
OEM_REAR_H       = 132;
OEM_FRONT_H      = 44;
OEM_WALL_TH      = 8;
OEM_SHELL_TH     = 6;
OEM_FILLET       = 3.5;
LEAN_ANGLE       = 9;
SLOT_CLEAR_Y     = 1.4;

/* --- Split-print joints (sides + center) --- */
SIDE_PART_W      = 22;           // mm from each outer edge (side STLs)
JOINT_OVERLAP    = 4;            // glue/peg overlap at seam
JOINT_Z          = [32, 72, 112]; // peg/heights along stand
JOINT_PEG_D      = 2.9;
JOINT_HOLE_D     = 3.4;
X_LEFT_OUTER     = -OEM_WIDTH / 2;
X_RIGHT_OUTER    = OEM_WIDTH / 2;
X_LEFT_INNER     = X_LEFT_OUTER + SIDE_PART_W;
X_RIGHT_INNER    = X_RIGHT_OUTER - SIDE_PART_W;
X_CENTER_LEFT    = X_LEFT_INNER - JOINT_OVERLAP;
X_CENTER_RIGHT   = X_RIGHT_INNER + JOINT_OVERLAP;

/* --- Cutout / fold --- */
LIP_WIDTH_CLEAR  = 0.5;
LIP_DEPTH_CLEAR  = 0.8;
LIP_WIDTH        = CUTOUT_W - LIP_WIDTH_CLEAR;
LIP_DEPTH        = CUTOUT_D - LIP_DEPTH_CLEAR;
FOLD_STEP_H      = 9.5;
HOOK_H           = 3.0;
HOOK_INSET       = 1.0;

/* --- Pogo pins --- */
PIN_COUNT        = 2;
PIN_DIAM         = 1.75;
PIN_HOLE_D       = PIN_DIAM + 0.35;
PIN_BOSS_OD      = 7;
PIN_BOSS_H       = 8;
CONTACT_SPACING  = 19.0;
CONTACT_HEIGHT   = 6.5;
CONTACT_INSET    = 2.0;

/* --- TP4056 bay --- */
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

module clip_x(x0, x1) {
  intersection() {
    children();
    translate([(x0 + x1) / 2, -6, 78])
      cube([x1 - x0 + 0.01, 230, 210], center = true);
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

module oem_profile_2d() {
  x_rear = -OEM_BASE_D / 2 - OEM_REAR_EXT;
  x_front = OEM_BASE_D / 2 + 6;
  x_slot_front = OEM_BASE_D / 2 - 16;
  z0 = OEM_FOOT_H;

  polygon(points = [
    [x_rear, z0],
    [x_front, z0],
    [x_front - 4, z0 + OEM_FRONT_H + 6],
    [x_slot_front, z0 + OEM_FRONT_H - 2],
    [x_slot_front - 10, z0 + OEM_FRONT_H + 12],
    [-OEM_BASE_D / 2 + 2, z0 + OEM_REAR_H],
    [-OEM_BASE_D / 2 - OEM_REAR_EXT + 8, z0 + 5],
    [x_rear + 5, z0]
  ]);
}

module oem_outer_solid() {
  minkowski() {
    rotate([0, 90, 0])
      linear_extrude(OEM_WIDTH - 2 * OEM_FILLET, center = true)
        oem_profile_2d();
    sphere(r = OEM_FILLET, $fn = 24);
  }
}

module keyboard_slot_cut() {
  slot_y = KB_THICKNESS + 2 * SLOT_CLEAR_Y;
  slot_top = OEM_FOOT_H + OEM_REAR_H + 25;
  pivot_y = -OEM_BASE_D / 2 + 10;

  translate([0, pivot_y, OEM_FOOT_H + OEM_REAR_H / 2])
    rotate([-LEAN_ANGLE, 0, 0])
      cube([OEM_WIDTH - 2 * OEM_SHELL_TH + 4, slot_y + 0.5, slot_top], center = true);
}

FOLD_Y = OEM_BASE_D / 2 - LIP_DEPTH / 2 - 10;
FOLD_Z = OEM_FOOT_H;

module cradle_solid_shell() {
  difference() {
    oem_outer_solid();
    keyboard_slot_cut();
    electronics_cavity();
    usb_c_slot();
    wire_channel(FOLD_Z + FOLD_STEP_H);
  }
}

// Dowel pockets on inner face of each side part
module side_joint_holes(face_x) {
  for (zz = JOINT_Z)
    translate([face_x, 2, zz])
      rotate([0, 90, 0])
        cylinder(d = JOINT_HOLE_D, h = JOINT_OVERLAP + 6, center = true);
}

// Pegs on center part, protruding toward sides
module center_joint_pegs(dir) {
  face_x = dir < 0 ? X_CENTER_LEFT : X_CENTER_RIGHT;
  for (zz = JOINT_Z)
    translate([face_x, 2, zz])
      rotate([0, -90 * dir, 0])
        cylinder(d = JOINT_PEG_D, h = JOINT_OVERLAP + 0.4, center = false);
}

module part_side_left() {
  difference() {
    clip_x(X_LEFT_OUTER - 1, X_LEFT_INNER) cradle_solid_shell();
    side_joint_holes(X_LEFT_INNER - JOINT_OVERLAP / 2);
  }
}

module part_side_right() {
  difference() {
    clip_x(X_RIGHT_INNER, X_RIGHT_OUTER + 1) cradle_solid_shell();
    side_joint_holes(X_RIGHT_INNER + JOINT_OVERLAP / 2);
  }
}

module part_center() {
  union() {
    clip_x(X_CENTER_LEFT, X_CENTER_RIGHT) cradle_solid_shell();
    contact_fold(FOLD_Y, FOLD_Z);
    center_joint_pegs(-1);
    center_joint_pegs(1);
  }
}

module cradle_body() {
  union() {
    part_side_left();
    part_side_right();
    part_center();
  }
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
  color("DarkGoldenrod") part_side_left();
  color("DarkGoldenrod") part_side_right();
  color("DimGray") part_center();
  ghost_keyboard();
}

if (PART == "side_left") {
  part_side_left();
} else if (PART == "side_right") {
  part_side_right();
} else if (PART == "center") {
  part_center();
} else if (PART == "cradle") {
  cradle_body();
} else if (PART == "electronics_cover") {
  electronics_cover();
} else if (PART == "base" || PART == "back") {
  cradle_body();
} else {
  assembly();
}