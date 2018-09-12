$fn = 100;

// "Base" structure
base_width = 2;

// Outer ring used for measurement 
arc_len   = 70;
arc_od    = 100;
arc_width = 15;

// arms support the ring
arm_width = arc_width * 0.75;

// Length of the pull from the pivot
pull_offset = 30;

pin_radius = 1;

// Hollow ring with an inner and outer diameter
module ring(od, id, w) {
  difference() {
    cylinder(r=od, h=w);

    translate([0, 0, -1])
    cylinder(r=id, h=w+2);
  }
}

// Creates an arm with a pivot-point around the origin. It will extend the
// origin with a rounded pivot. The arm is centered in the Y-axis pointed to
// 12:00.
module ring_arm(width, length, depth) {
  translate([-width/2, 0, 0])
  cube([width, length, depth]);

  cylinder(r=width/2, h=depth);
}

// "Base" design with the ring fully extended. Needs to be culled down to the
// appropriate arc
module base_shape() {
  arc_mid = arc_od - (arc_width / 2);

  ring(
    od = arc_od,
    id = arc_od - arc_width,
    w  = base_width);

  ring_arm(
    width  = arm_width,
    length = arc_mid,
    depth  = base_width);

  rotate([0, 0, arc_len])
  ring_arm(
    width  = arm_width,
    length = arc_mid,
    depth  = base_width);
}

// Base stock clipped to `arc_len`.
module base_stock() {
  difference() {
    base_shape();

    // Vertical clipping region
    translate([arm_width/2, -arc_od-1, -1])
    cube([arc_od, arc_od*2+2, base_width+2]);

    // Horizontal clipping region
    rotate([0, 0, arc_len])
    translate([-arc_od-(arm_width/2), -arc_od-1, -1])
    cube([arc_od, arc_od*2+2, base_width+2]);
  }
}

module tick_mark(h, w, id, depth, deg) {
  rotate([0, 0, deg])
  translate([-w/2, id, base_width-depth])
  cube([w, h, depth+1]);
}

// Tick marks for every 1mm of pull along the arc
module tick_marks(lo, hi, inc=1) {
  pad   = 3;
  width = 0.2;

  max_half_tick = 45;
  max_quar_tick = 22;

  radius = (arc_od-arc_width) + pad;
  height = arc_width - (pad*2);

  // Whole ticks
  for(mm = [lo : inc : hi]) {
    deg = atan(mm / pull_offset);

    tick_mark(
      h     = height,
      w     = width,
      id    = radius,
      depth = 1,
      deg   = deg);
  }

  // Half ticks
  for(mm = [lo + inc/2 : inc : hi]) {
    deg = atan(mm / pull_offset);

    if(deg < max_half_tick) {
      tick_mark(
        h     = height/2,
        w     = width,
        id    = radius,
        depth = 1,
        deg   = deg);
    }
  }

  // Low quarter-ticks
  for(mm = [lo + inc/4 : inc : hi]) {
    deg = atan(mm / pull_offset);

    if(deg < max_quar_tick) {
      tick_mark(
        h     = height/4,
        w     = width,
        id    = radius,
        depth = 1,
        deg   = deg);
    }
  }
  // High quarter-ticks
  for(mm = [(lo+1) - inc/4 : inc : hi]) {
    deg = atan(mm / pull_offset);

    if(deg < max_quar_tick) {
      tick_mark(
        h     = height/4,
        w     = width,
        id    = radius,
        depth = 1,
        deg   = deg);
    }
  }
}

module base() {
  difference() {
    base_stock();

    tick_marks(2, 56, 1);

    // Axis pin hole
    translate([0, 0, -1])
    cylinder(r=pin_radius, h=base_width+2);
  }
}

module pointer() {
  pointer_width = arc_width / 2;



  difference() {
    translate([0, 0, base_width])
    ring_arm(
      length = arc_od - (arc_width/2),
      width  = pointer_width,
      depth  = base_width);

    // Pivot hole
    translate([0, 0, base_width-1])
    cylinder(r=pin_radius, h=base_width+2);

    // Clamp hole
    translate([0, pull_offset, base_width-1])
    cylinder(r=pin_radius, h=base_width+2);

    // Right Pointer
    translate([pointer_width, arc_od-(arc_width/2), (base_width*2)-1])
    rotate([0, 0, 45])
    cube([arc_width, arc_width, base_width+2], center=true);

    // Left Pointer
    translate([-pointer_width, arc_od-(arc_width/2), (base_width*2)-1])
    rotate([0, 0, 45])
    cube([arc_width, arc_width, base_width+2], center=true);
  }
}

base();

color([0.7, 0.7, 0.7, 0.7])
rotate([0, 0, 20])
pointer();

// ring(od=ring_od, id=ring_id, w=ring_width);
// 
// ring_arm(width=ring_width, length=90, depth=ring_width);
// 
// rotate([0, 0, 70]) ring_arm(width=ring_width, length=90, depth=ring_width);
