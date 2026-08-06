// SPDX-License-Identifier: CERN-OHL-P-2.0
// Tumbuh Cap v0.1 — gravity-separated plant metabolism pilot
// Copyright (c) 2026 Paul Carver Tiffany III
//
// This is an experimental, unvalidated prototype. It is not a pressure vessel,
// potable-water device, medical device, or food-contact certification.
//
// Export one part at a time by changing `part` below.

$fn = 96;
part = "assembly"; // "cap", "cartridge", "collar", "test_coupon", "assembly"

// ---------- Primary dimensions (millimetres) ----------
outer_d = 120;
plate_t = 4;
seat_d = 112;
seat_h = 14;
seat_wall = 2.4;

plant_opening_d = 44;
plant_collar_h = 18;
plant_collar_wall = 3;
collar_insert_clearance = 0.45;

clean_port_x = -35;
dirty_port_x = 35;
port_y = 0;
clean_grommet_hole_d = 8.2; // tune to the actual grommet/tube
vent_hole_d = 3.2;

cartridge_body_d = 34;
cartridge_clearance = 0.45;
cartridge_h = 38;
cartridge_wall = 2.4;
cartridge_floor = 2.4;
cartridge_flange_d = 43;
cartridge_flange_t = 3;
slot_w = 3;
slot_h = 14;
slot_count = 12;

label_h = 0.7;

// ---------- Helpers ----------
module ring(od, id, h) {
  difference() {
    cylinder(d = od, h = h);
    translate([0, 0, -0.1]) cylinder(d = id, h = h + 0.2);
  }
}

module rounded_bar(length, width, height) {
  hull() {
    translate([-length/2 + width/2, 0, 0]) cylinder(d = width, h = height);
    translate([ length/2 - width/2, 0, 0]) cylinder(d = width, h = height);
  }
}

// ---------- Cap ----------
module cap_body() {
  difference() {
    union() {
      // Main load-bearing plate.
      cylinder(d = outer_d, h = plate_t);

      // Lower locating skirt: seats inside a pot or test fixture but does not seal.
      translate([0, 0, -seat_h])
        ring(seat_d, seat_d - 2 * seat_wall, seat_h);

      // Central plant collar.
      translate([0, 0, plate_t])
        ring(plant_opening_d + 2 * plant_collar_wall,
             plant_opening_d,
             plant_collar_h);

      // Raised, tactile channel markers. These are deliberately asymmetric so
      // the channels remain distinguishable even when labels are wet or dirty.
      translate([clean_port_x, port_y - 13, plate_t])
        rounded_bar(24, 3.2, 2.2);
      translate([dirty_port_x, port_y - 13, plate_t])
        rotate([0, 0, 45]) rounded_bar(17, 3.2, 2.2);
      translate([dirty_port_x, port_y - 13, plate_t])
        rotate([0, 0, -45]) rounded_bar(17, 3.2, 2.2);
    }

    // Plant opening.
    translate([0, 0, -seat_h - 0.2])
      cylinder(d = plant_opening_d,
               h = seat_h + plate_t + plant_collar_h + 0.4);

    // CLEAN: a simple, isolated pass-through for silicone tube + grommet.
    translate([clean_port_x, port_y, -seat_h - 0.2])
      cylinder(d = clean_grommet_hole_d,
               h = seat_h + plate_t + 0.4);

    // DIRTY: removable cartridge bay. The flange sits on the top plate.
    translate([dirty_port_x, port_y, -seat_h - 0.2])
      cylinder(d = cartridge_body_d + 2 * cartridge_clearance,
               h = seat_h + plate_t + 0.4);

    // Passive vent / overflow tell-tale. This is intentionally open and visible.
    translate([0, -48, -seat_h - 0.2])
      cylinder(d = vent_hole_d,
               h = seat_h + plate_t + 0.4);
  }
}

// ---------- Removable microbial / biochar cartridge ----------
module reactor_cartridge() {
  difference() {
    union() {
      // Top flange.
      cylinder(d = cartridge_flange_d, h = cartridge_flange_t);

      // Basket body hangs below the cap.
      translate([0, 0, -cartridge_h])
        cylinder(d = cartridge_body_d, h = cartridge_h);
    }

    // Open basket cavity, preserving a printable floor.
    translate([0, 0, -cartridge_h + cartridge_floor])
      cylinder(d = cartridge_body_d - 2 * cartridge_wall,
               h = cartridge_h + cartridge_flange_t + 0.2);

    // Side slots: wide enough to resist instant clogging, narrow enough to retain
    // coarse mesh, biochar chips, or mulch. Add a physical mesh liner in use.
    for (a = [0 : 360 / slot_count : 360 - 360 / slot_count]) {
      rotate([0, 0, a])
        translate([cartridge_body_d / 2 - cartridge_wall / 2, 0, -cartridge_h / 2])
          cube([cartridge_wall + 1.2, slot_w, slot_h], center = true);
    }

    // Bottom drainage holes. The cartridge is a gravity filter, not a reservoir.
    for (a = [0 : 45 : 315]) {
      translate([8 * cos(a), 8 * sin(a), -cartridge_h - 0.2])
        cylinder(d = 3.2, h = cartridge_floor + 0.5);
    }
    translate([0, 0, -cartridge_h - 0.2])
      cylinder(d = 4.2, h = cartridge_floor + 0.5);
  }
}

// ---------- Split plant collar insert ----------
module plant_collar_insert(stem_d = 14, insert_h = 12) {
  insert_od = plant_opening_d - 2 * collar_insert_clearance;
  difference() {
    ring(insert_od, stem_d, insert_h);

    // Radial split: lets the collar flex around an existing stem.
    translate([0, -1.4, -0.2])
      cube([insert_od / 2 + 1, 2.8, insert_h + 0.4]);

    // Four soft-relief cuts reduce stem pressure. Use foam or silicone around
    // living tissue; printed plastic should not clamp the stem directly.
    for (a = [45, 135, 225, 315]) {
      rotate([0, 0, a])
        translate([stem_d / 2, -0.6, -0.2])
          cube([(insert_od - stem_d) / 2, 1.2, insert_h + 0.4]);
    }
  }
}

// ---------- Cheap fit/leak coupon ----------
module test_coupon() {
  // Print this before the full cap. It validates grommet fit, cartridge clearance,
  // wall thickness, and slicer settings using a small amount of material.
  difference() {
    union() {
      cube([72, 38, plate_t]);
      translate([18, 19, plate_t])
        cylinder(d = 16, h = 8);
    }

    translate([18, 19, -0.2])
      cylinder(d = clean_grommet_hole_d, h = plate_t + 8.4);

    translate([51, 19, -0.2])
      cylinder(d = cartridge_body_d + 2 * cartridge_clearance,
               h = plate_t + 0.4);
  }

  translate([51, 19, plate_t])
    difference() {
      cylinder(d = cartridge_flange_d + 4, h = 1.2);
      cylinder(d = cartridge_body_d + 2 * cartridge_clearance, h = 1.4);
    }
}

// ---------- Output selector ----------
if (part == "cap") {
  cap_body();
} else if (part == "cartridge") {
  translate([0, 0, cartridge_h]) reactor_cartridge();
} else if (part == "collar") {
  plant_collar_insert();
} else if (part == "test_coupon") {
  test_coupon();
} else {
  // Exploded assembly preview. Do not export this mode as one STL.
  color([0.15, 0.17, 0.16]) cap_body();
  color([0.35, 0.22, 0.08])
    translate([dirty_port_x, port_y, 52]) reactor_cartridge();
  color([0.15, 0.45, 0.20])
    translate([0, 0, 32]) plant_collar_insert();
}
