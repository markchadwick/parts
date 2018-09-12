$fn = 30;

module screw(d) {
  head_outer = 8;
  head_inner = 5;
  head_depth = 2;

  radius = 1.2;

  translate([0, 0, -head_depth])
  cylinder(
    r1 = head_inner/2,
    r2 = head_outer/2,
    h  = head_depth);

  translate([0, 0, -d])
  cylinder(radius, h=d);
}

module plate(w, h, d, screw_hole=false) {
  difference() {
    cube([w, h, d]);

    if(screw_hole) {
      translate([w/2, h/2, d+0.5])
      screw(d+1);
    }
  }
}

module support(x0, y0, x1, y1, d=1) {
  rx = x1-x0;
  if(rx < 0) {
    echo("dx < 0", rx);
  }
  ry = y0-y1;
  if(ry < 0) {
    echo("dy < 0", rx);
  }

  ratio_y = ry / rx;

  difference() {
    translate([x0, y1])
    cube([rx, ry, d]);

    translate([x1, y0, -0.5])
    scale([1, ratio_y, 1])
    cylinder(r=x1-x0, h=d+1);
  }
}

module upper_support(w, l0, l1, l2) {
  rotate([0, -90, 0])
  support(
    x0 = 0,
    y0 = l0,
    x1 = l1,
    y1 = 0,
    d  = w);
}

module lower_support(w, d, l1, l2) {
  translate([w, -d, d])
  rotate([0, 90, 180])
  translate([-l1+d, l2, 0])
  support(
    x0 = 0,
    y0 = -d,
    x1 = l1,
    y1 = -l2,
    d  = w);
}


module _s_bracket(w, d, l0, l1, l2) {
  support_width = d/2;

  plate(w, l0, d, screw_hole=true);

  rotate([90, 0, 0])
  plate(w, l1, d);

  translate([0, -l2, l1])
  plate(w, l2, d);

  // Upper left support
  translate([support_width, 0, d])
  upper_support(support_width, l0, l1, l2);

  // Upper right support
  translate([w, 0, d])
  upper_support(support_width, l0, l1, l2);

  // Lower left support
  lower_support(support_width, d, l1, l2);

  // Lower right suport
  translate([w-support_width, 0, 0])
  lower_support(support_width, d, l1, l2);
}

module s_bracket(w, d, l0, l1, l2) {
  rotate([90, 0, 0])
  translate([-w/2, l2, -l1-d])
  _s_bracket(w, d, l0, l1, l2);
}

module bottom_bracket(w, d, r, l0, l1, l2) {
  support_w = 2.5;
  support_d = 4;

  difference() {
    union() {
      s_bracket(w, d, l0, l1, l2);

      translate([0, -r+3.3, 0])
      cylinder(r=r, h=l2);
    }

    translate([0, -r+3.3, support_d])
    cylinder(r=r-(support_w*2), h=l2-support_d+1);
  }
}

bottom_bracket(
  w  =25,
  d  = 5,
  r  = 25,
  l0 = 25,
  l1 = 20,
  l2 = 15);

// module screw() {
//   translate([12, 12, 24-screw_head_depth])
//   cylinder(
//     r1=screw_head_inner,
//     r2=screw_head_outer,
//     h=screw_head_depth);
//   
//   translate([12, 12])
//   cylinder(r=screw_radius, h=24);
// }
// 
// difference() {
//   cube(24);
//   screw();
// }

