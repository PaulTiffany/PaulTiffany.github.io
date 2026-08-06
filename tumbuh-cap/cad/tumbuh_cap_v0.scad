// SPDX-License-Identifier: CERN-OHL-P-2.0
// Tumbuh Cap v0.1.1 — gravity-separated plant metabolism pilot
// Copyright (c) 2026 Paul Carver Tiffany III
//
// EXPERIMENTAL / UNVALIDATED. Not a pressure vessel, potable-water device,
// medical device, or certified food-contact design.
//
// Export one part at a time. The value may be overridden from the command line:
// openscad -o cap.stl -D 'part="cap"' tumbuh_cap_v0.scad

$fn = 128;
part = "assembly"; // cap | cartridge | collar | test_coupon | assembly

// ---------- Nominal dimensions: measure real hardware before revision 1 ----------
outer_d = 120;
plate_t = 4;
seat_d = 112;
seat_h = 14;
seat_wall = 2.4;

plant_opening_d = 44;
plant_collar_h = 18;
plant_collar_wall = 3;
collar_insert_clearance = 0.45;
collar_stem_d = 14;

clean_port_x = -35;
dirty_port_x = 35;
port_y = 0;
clean_grommet_hole_d = 8.2;
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

// ---------- Main cap ----------
module cap_body() {
  difference() {
    union() {
      cylinder(d = outer_d, h = plate_t);

      // Locating skirt only: it deliberately does not create a watertight pot seal.
      translate([0, 0, -seat_h])
        ring(seat_d, seat_d - 2 * seat_wall, seat_h + 0.15);

      translate([0, 0, plate_t - 0.1])
        ring(plant_opening_d + 2 * plant_collar_wall,
             plant_opening_d,
             plant_collar_h + 0.1);

      // Tactile asymmetry: line = clean input; X = biological/dirty input.
      translate([clean_port_x, port_y - 13, plate_t - 0.1])
        rounded_bar(24, 3.2, 2.3);
      translate([dirty_port_x, port_y - 13, plate_t - 0.1])
        rotate([0, 0, 45]) rounded_bar(17, 3.2, 2.3);
      translate([dirty_port_x, port_y - 13, plate_t - 0.1])
        rotate([0, 0, -45]) rounded_bar(17, 3.2, 2.3);
    }

    translate([0, 0, -seat_h - 0.2])
      cylinder(d = plant_opening_d,
               h = seat_h + plate_t + plant_collar_h + 0.4);

    // Isolated clean-water tube/grommet pass-through.
    translate([clean_port_x, port_y, -seat_h - 0.2])
      cylinder(d = clean_grommet_hole_d,
               h = seat_h + plate_t + 0.4);

    // Removable biological cartridge bay.
    translate([dirty_port_x, port_y, -seat_h - 0.2])
      cylinder(d = cartridge_body_d + 2 * cartridge_clearance,
               h = seat_h + plate_t + 0.4);

    // Visible passive vent / overflow witness.
    translate([0, -48, -seat_h - 0.2])
      cylinder(d = vent_hole_d,
               h = seat_h + plate_t + 0.4);
  }
}

// ---------- Removable microbial / biochar cartridge ----------
module reactor_cartridge() {
  difference() {
    union() {
      cylinder(d = cartridge_flange_d, h = cartridge_flange_t);
      translate([0, 0, -cartridge_h])
        cylinder(d = cartridge_body_d, h = cartridge_h + 0.1);
    }

    // Open cavity; preserve a printable bottom floor.
    translate([0, 0, -cartridge_h + cartridge_floor])
      cylinder(d = cartridge_body_d - 2 * cartridge_wall,
               h = cartridge_h + cartridge_flange_t + 0.3);

    // Side apertures. Use a removable physical mesh liner in wet tests.
    for (a = [0 : 360 / slot_count : 360 - 360 / slot_count]) {
      rotate([0, 0, a])
        translate([cartridge_body_d / 2 - cartridge_wall / 2, 0, -cartridge_h / 2])
          cube([cartridge_wall + 1.4, slot_w, slot_h], center = true);
    }

    for (a = [0 : 45 : 315]) {
      translate([8 * cos(a), 8 * sin(a), -cartridge_h - 0.2])
        cylinder(d = 3.2, h = cartridge_floor + 0.5);
    }
    translate([0, 0, -cartridge_h - 0.2])
      cylinder(d = 4.2, h = cartridge_floor + 0.5);
  }
}

// ---------- Single-piece split collar ----------
module plant_collar_insert(stem_d = collar_stem_d, insert_h = 12) {
  insert_od = plant_opening_d - 2 * collar_insert_clearance;
  difference() {
    ring(insert_od, stem_d, insert_h);

    // One radial cut preserves a connected flexible C-ring. A soft foam or
    // silicone liner—not printed plastic—should touch living stem tissue.
    translate([0, -1.4, -0.2])
      cube([insert_od / 2 + 1, 2.8, insert_h + 0.4]);
  }
}

// ---------- Low-cost dimensional coupon ----------
module test_coupon() {
  difference() {
    union() {
      cube([72, 38, plate_t]);
      translate([18, 19, plate_t - 0.1])
        cylinder(d = 16, h = 8.1);

      // Cartridge flange witness; reduced diameter keeps the coupon compact.
      translate([51, 19, plate_t - 0.1])
        ring(cartridge_body_d + 7,
             cartridge_body_d + 2 * cartridge_clearance,
             1.3);
    }

    translate([18, 19, -0.2])
      cylinder(d = clean_grommet_hole_d, h = plate_t + 8.4);

    translate([51, 19, -0.2])
      cylinder(d = cartridge_body_d + 2 * cartridge_clearance,
               h = plate_t + 1.6);
  }
}

if (part == "cap") {
  cap_body();
} else if (part == "cartridge") {
  translate([0, 0, cartridge_h]) reactor_cartridge();
} else if (part == "collar") {
  plant_collar_insert();
} else if (part == "test_coupon") {
  test_coupon();
} else {
  // Exploded preview only. Do not export assembly mode as a single STL.
  color([0.15, 0.17, 0.16]) cap_body();
  color([0.35, 0.22, 0.08])
    translate([dirty_port_x, port_y, 52]) reactor_cartridge();
  color([0.15, 0.45, 0.20])
    translate([0, 0, 32]) plant_collar_insert();
}
