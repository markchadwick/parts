$fn = 30;

use <../support.scad>;
use <../screws.scad>;

inches = 25.4;

holder_w = 6;
holder_x = 6 * inches;
holder_y = 1 * inches;
holder_z = 2 * inches;

slot_n = 10;
slot_d = 2;
slot_z = holder_z - (0.5 * inches);

support_d = 9;

// /////////////////////////////////////////////////////////////////////////////
// Backplate
module backplate() {
  difference() {
    rotate([90, 0, 0])
    translate([0, 0, -holder_w])
    cube([holder_x, holder_y, holder_w]);

    translate([holder_x*0.25, -0.1, holder_y/2])
    rotate([-90, 0, 0])
    screw_hole(20);

    translate([holder_x*0.75, -0.1, holder_y/2])
    rotate([-90, 0, 0])
    screw_hole(20);
  }
}

// /////////////////////////////////////////////////////////////////////////////
// Frontplate
module frontplate() {
  rotate([90, 0, 0])
  translate([0, -holder_w, -holder_w])
  cube([holder_x, holder_w, holder_z+holder_w]);
}

// /////////////////////////////////////////////////////////////////////////////
// Cable slots
module slot() {
  chamfer_d = slot_d*4;

  rotate([90, 0, 0])
  translate([-slot_d/2, -holder_w-1, holder_z-slot_z])
  cube([slot_d, holder_w+2, slot_z+1]);

  // chamfer
  rotate([90, 0, 0])
  translate([0, 0, holder_z])
  rotate([0, 45, 0])
  translate([-chamfer_d/2, -holder_w-1, -chamfer_d/2])
  cube([chamfer_d, holder_w+2, chamfer_d]);
}

module slots() {
  for(i = [1 : slot_n]) {
    slot_spacing = holder_x / (slot_n + 1);

    translate([slot_spacing*i, 0, 0])
    slot();
  }
}

// /////////////////////////////////////////////////////////////////////////////
// Supports
module supports() {
  // left support
  translate([0, -holder_z, 0])
  linear_support(
    y = holder_z,
    z = holder_y,
    w = holder_w,
    d = support_d);

  // Right support
  translate([holder_x-holder_w, -holder_z, 0])
  linear_support(
    y = holder_z,
    z = holder_y,
    w = holder_w,
    d = support_d);

  // Center support
  translate([(holder_x-holder_w)/2, -holder_z, 0])
  linear_support(
    y = holder_z,
    z = holder_y,
    w = holder_w,
    d = support_d);
}

// /////////////////////////////////////////////////////////////////////////////
// Part
difference() {
  union() {
    frontplate();
    backplate();
    supports();
  }
  slots();
}
