// Logitech diNovo Edge charging cradle
// Outer size matches the factory stand: 135 x 87 x 85.5 mm (W x D x H).
// Two fins, centre slot, pogo pins, TP4056 mounting holes, rear USB-C opening.
//
//   openscad -D 'PART="cradle"' -o stl/dinovo_cradle.stl openscad/dinovo_cradle.scad
//   ./scripts/export-stl.sh

PART = "assembly";
// assembly | cradle | cover | exploded

/* --- Factory envelope (Logicool / PC Watch, 2007) --- */
WIDTH        = 135;    // X, left-right
DEPTH        = 87;     // Y, rear (-) to front (+)
HEIGHT       = 85.5;   // Z, rear crest
FRONT_H      = 62;     // front fin crest
FOOT_H       = 18;
EDGE_R       = 2.8;    // outer edge radius; keep below half the throat width
LEAN         = 12;     // keyboard lean back from vertical, degrees

/* --- Keyboard --- */
KB_WIDTH     = 409;
KB_DEPTH     = 211;    // up the keys, once stood in the slot
KB_THICK     = 12;     // official edge thickness; set 19.5 if you measure the thick body
CUTOUT_W     = 101.6;  // bottom-centre recess, 4 in
CUTOUT_CLEAR = 3.0;    // total width clearance of the centre pad in that recess

/* --- Pogo pins ---
   Two slots on the centre pad. A straight 1.5 mm sleeve, 16 mm long
   (the usual "pogo pin 1.5 x 16") drops in from the top. The slot is
   longer than the sleeve so you can slide the pin sideways onto the
   keyboard pad, then it stops on the narrow exit. Solder the tail in
   the bay and run that wire to the TP4056. */
CONTACT_SPACING = 18.0;   // nominal centre to centre, left-right
PIN_OD          = 1.5;    // sleeve diameter
PIN_LEN         = 16.0;   // overall pin length, plunger extended
PIN_TIP         = 2.6;    // how far the extended pin stands above the pad
PIN_SLOT_W      = 2.05;   // front-back, clearance around the 1.5 mm sleeve
PIN_SLOT_L      = 8.0;    // left-right, room to slide the pin
PIN_EXIT_W      = 1.35;   // narrower than the sleeve, wire still passes

/* --- TP4056 USB-C module with four mounting holes ---
   Defaults match the common 38 x 22 mm protected module
   (four M2 holes, ~3 mm in from each edge, USB-C on a short edge).
   Measure your board and edit these if it differs. The small
   hole-less 29 x 17 mm module also sits in the same nest: push its
   USB-C end against the rear stop and leave the screws out. */
BOARD_L        = 38.0;   // depth, USB-C on the rear short edge
BOARD_W        = 22.0;   // left-right
BOARD_T        = 1.6;
HOLE_INSET_L   = 3.0;    // hole centre to the short (USB / far) edges
HOLE_INSET_W   = 3.0;    // hole centre to the long edges
MOUNT_HOLE_D   = 1.75;   // M2 self-tap into the printed boss
MOUNT_BOSS_D   = 6.4;
MOUNT_BOSS_H   = 5.0;
USB_PROTRUDE   = 2.0;    // how far the receptacle sticks past the PCB
USB_HOLE_W     = 13.5;   // opening the cable plug passes through
USB_HOLE_H     = 7.4;
USB_Z_ABOVE    = 3.4;    // receptacle centre above the PCB bottom face
POCKET_SIDE    = 4.0;    // extra pocket width each side of the board
POCKET_FRONT   = 18.0;   // empty length in front of the board (wires)
POCKET_CEILING = 15.2;   // top of the bay inside the foot
COVER_T        = 2.2;
COVER_SCREW_D  = 1.75;   // M2 self-tap, cover to foot
COVER_CLEAR_D  = 2.5;

$fn = 48;

Y_REAR = -DEPTH / 2;
Y_FRONT = DEPTH / 2;

// Rear wall the USB-C receptacle tunnels through. The board stops against
// the inside of this wall; the receptacle crosses it to the outer face.
REAR_WALL = 3.2;
BOARD_REAR_Y = Y_REAR + REAR_WALL + 0.4;
BOARD_FRONT_Y = BOARD_REAR_Y + BOARD_L;
BOARD_CY = (BOARD_REAR_Y + BOARD_FRONT_Y) / 2;
HOLE_YS = [BOARD_REAR_Y + HOLE_INSET_L, BOARD_FRONT_Y - HOLE_INSET_L];
HOLE_XS = [-(BOARD_W / 2 - HOLE_INSET_W), BOARD_W / 2 - HOLE_INSET_W];

POCKET_X = BOARD_W / 2 + POCKET_SIDE;
POCKET_Y0 = Y_REAR + REAR_WALL;
POCKET_Y1 = BOARD_FRONT_Y + POCKET_FRONT;
SEAT_Z = 23.5;
PIN_Y = -1.0;

// Profile points are [depth Y, height Z]. polygon_2d swaps them so a
// rotate([0, -90, 0]) extrusion comes out standing up, width along X.
module profile_2d() {
  pts = [
    [Y_REAR, 0],
    [Y_FRONT, 0],
    [Y_FRONT, 12],
    [38, 16],
    [35, 30],
    [39, 48],
    [42, 58],
    [38, FRONT_H],
    [27, FRONT_H],
    [21, 50],
    [14, 34],
    [8, 22],
    [3, 17.4],
    [-9, 17.4],
    [-14, 24],
    [-17, 42],
    [-19, 70],
    [-23, HEIGHT],
    [-36, HEIGHT],
    [-39.5, 70],
    [-42.4, 34],
    [Y_REAR, 14]
  ];
  polygon([for (p = pts) [p[1], p[0]]]);
}

module rounded_shell() {
  minkowski() {
    rotate([0, -90, 0])
      linear_extrude(WIDTH - 2 * EDGE_R, center = true, convexity = 8)
        offset(r = -EDGE_R, $fn = 16)
          profile_2d();
    sphere(r = EDGE_R, $fn = 20);
  }
}

module flat_bottom() {
  translate([0, 0, -40])
    cube([WIDTH + 40, DEPTH + 40, 40], center = true);
}

module pocket_void() {
  hull() {
    translate([-POCKET_X + 3, POCKET_Y0 + 3, -1])
      cylinder(d = 6, h = POCKET_CEILING + 1);
    translate([POCKET_X - 3, POCKET_Y0 + 3, -1])
      cylinder(d = 6, h = POCKET_CEILING + 1);
    translate([-POCKET_X + 3, POCKET_Y1 - 3, -1])
      cylinder(d = 6, h = POCKET_CEILING + 1);
    translate([POCKET_X - 3, POCKET_Y1 - 3, -1])
      cylinder(d = 6, h = POCKET_CEILING + 1);
  }
}

// Step the cover sits in, so the underside stays flush.
module cover_rabbet() {
  // Shelf for the lid. Kept inside the outer shell so the rear wall stays closed.
  translate([-POCKET_X - 0.8, POCKET_Y0 - 0.25, -0.2])
    cube([
      2 * POCKET_X + 1.6,
      (POCKET_Y1 - POCKET_Y0) + 1.15,
      COVER_T + 0.45
    ]);
}

module usb_hole() {
  // Rounded slot the USB-C plug passes through. Centred on the receptacle.
  span = REAR_WALL + 14;
  mid_y = Y_REAR + 1.2;
  hw = max(USB_HOLE_W / 2 - USB_HOLE_H / 2, 0.2);
  hull() {
    for (x = [-hw, hw])
      translate([x, mid_y, SEAT_USB_Z()])
        rotate([90, 0, 0])
          cylinder(d = USB_HOLE_H, h = span, center = true, $fn = 40);
  }
}

function SEAT_USB_Z() = COVER_T + MOUNT_BOSS_H + USB_Z_ABOVE;

module mounting_bosses() {
  for (x = HOLE_XS, y = HOLE_YS)
    translate([x, y, COVER_T])
      cylinder(d = MOUNT_BOSS_D, h = MOUNT_BOSS_H);
}

module mounting_holes() {
  for (x = HOLE_XS, y = HOLE_YS)
    translate([x, y, COVER_T - 0.05])
      cylinder(d = MOUNT_HOLE_D, h = MOUNT_BOSS_H + 0.2);
}

module cover_screw_positions() {
  // Two along each side rim, clear of the bay and the outer shell.
  for (x = [-1, 1], y = [POCKET_Y0 + 8, POCKET_Y1 - 8])
    translate([x * (POCKET_X + 6.5), y, 0])
      children();
}

module cover_screw_pilots() {
  cover_screw_positions()
    translate([0, 0, -0.2])
      cylinder(d = COVER_SCREW_D, h = 10);
}

module contact_pad() {
  pad_w = CUTOUT_W - CUTOUT_CLEAR;
  // Buried into the valley floor so it fuses with the shell.
  translate([-pad_w / 2, -9, 14.2])
    cube([pad_w, 16, SEAT_Z - 14.2]);
  // Lip the keyboard recess hooks behind, so it cannot slide forward.
  translate([-pad_w / 2, 5.6, SEAT_Z - 1.6])
    cube([pad_w, 3.2, 4.4]);
}

function PIN_GRIP() = PIN_LEN - PIN_TIP;

// Rounded slot, length along X, width along Y, extruded up from the origin.
module pin_slot_prism(len, wid, h) {
  span = max(len - wid, 0);
  hull() {
    translate([-span / 2, 0, 0]) cylinder(d = wid, h = h, $fn = 28);
    translate([ span / 2, 0, 0]) cylinder(d = wid, h = h, $fn = 28);
  }
}

// Towers under the pad so each slot is deep enough for a 16 mm pin.
module pin_posts() {
  for (x = [-CONTACT_SPACING / 2, CONTACT_SPACING / 2])
    translate([x - PIN_SLOT_L / 2 - 1.4, PIN_Y - PIN_SLOT_W / 2 - 1.6, 8.6])
      cube([PIN_SLOT_L + 2.8, PIN_SLOT_W + 3.2, SEAT_Z - 8.6]);
}

module pin_slots() {
  grip = PIN_GRIP();
  for (x = [-CONTACT_SPACING / 2, CONTACT_SPACING / 2]) {
    // Sleeve slot, open through the top of the pad.
    translate([x, PIN_Y, SEAT_Z - grip])
      pin_slot_prism(PIN_SLOT_L, PIN_SLOT_W, grip + 6);
    // Tail exit into the bay. Narrower than the sleeve, so the pin stops.
    translate([x, PIN_Y, 6.2])
      pin_slot_prism(PIN_SLOT_L, PIN_EXIT_W, (SEAT_Z - grip) - 6.2 + 0.8);
  }
}

module foot_dimples() {
  for (x = [-1, 1], y = [-1, 1])
    translate([x * (WIDTH / 2 - 12), y * (DEPTH / 2 - 10), -0.2])
      cylinder(d = 8, h = 1.3);
}

module cradle_solid() {
  difference() {
    union() {
      difference() {
        rounded_shell();
        flat_bottom();
        pocket_void();
        cover_rabbet();
        usb_hole();
        foot_dimples();
      }
      contact_pad();
      pin_posts();
    }
    pin_slots();
    cover_screw_pilots();
  }
}

module cover_plate() {
  difference() {
    union() {
      translate([-POCKET_X - 0.45, POCKET_Y0 + 0.1, 0])
        cube([
          2 * POCKET_X + 0.9,
          (POCKET_Y1 - POCKET_Y0) + 0.55,
          COVER_T
        ]);
      mounting_bosses();
    }
    mounting_holes();
    // Corner screws: clearance and a countersink so the head sits flush.
    cover_screw_positions() {
      translate([0, 0, -0.1])
        cylinder(d = COVER_CLEAR_D, h = COVER_T + 0.3);
      translate([0, 0, COVER_T - 1.35])
        cylinder(d1 = COVER_CLEAR_D, d2 = 4.6, h = 1.5);
    }
  }
}

module ghost_pins() {
  for (x = [-CONTACT_SPACING / 2, CONTACT_SPACING / 2])
    color([0.85, 0.65, 0.2])
      translate([x, PIN_Y, SEAT_Z - PIN_GRIP()])
        cylinder(d = PIN_OD, h = PIN_LEN, $fn = 24);
}

module ghost_keyboard() {
  // Bottom on the centre pad, leaning back onto the tall fin.
  color([0.62, 0.64, 0.67, 0.82])
    translate([0, 0, SEAT_Z])
      rotate([LEAN, 0, 0])
        translate([0, 0, KB_DEPTH / 2])
          cube([KB_WIDTH, KB_THICK, KB_DEPTH], center = true);
}

module ghost_board() {
  color([0.15, 0.45, 0.75, 0.55])
    translate([-BOARD_W / 2, BOARD_REAR_Y, COVER_T + MOUNT_BOSS_H])
      cube([BOARD_W, BOARD_L, BOARD_T]);
  color([0.85, 0.85, 0.9, 0.8])
    translate([0, BOARD_REAR_Y - USB_PROTRUDE, SEAT_USB_Z()])
      cube([9, USB_PROTRUDE + 1.2, 3.2], center = true);
}

module assembly() {
  color("#1c1c1c") cradle_solid();
  color("#242424") cover_plate();
  ghost_board();
  ghost_pins();
  ghost_keyboard();
  // USB-C lead leaving the rear of the foot.
  color("#141414")
    translate([0, Y_REAR - 16, SEAT_USB_Z()])
      rotate([90, 0, 0])
        cylinder(d = 3.4, h = 28, $fn = 24);
}

module exploded() {
  color("#1c1c1c") cradle_solid();
  translate([0, 0, -14]) {
    color("#2a2a2a") cover_plate();
    ghost_board();
  }
  ghost_keyboard();
}

if (PART == "cradle") {
  color("#1a1a1a") cradle_solid();
} else if (PART == "cover") {
  color("#242424") cover_plate();
} else if (PART == "exploded") {
  exploded();
} else {
  assembly();
}
