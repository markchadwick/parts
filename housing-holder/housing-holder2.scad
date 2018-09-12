$fn = 50;

width = 35;
depth = 5;

// /////////////////////////////////////////////////////////////////////////////
// Backing plate

module backplate() {
  screw_r = 4.3/2;
  head_or = 8.2/2;
  head_ir = 3.3/2;
  head_h  = 3;

  difference() {
    cube([width, width*2, depth]);

    translate([width/2, (width*1.5), -1])
    cylinder(r=screw_r, h=depth+2); 

    translate([width/2, (width*1.5), depth+0.01-head_h])
    cylinder(r1=head_ir, r2=head_or, h=head_h);
  }
}

// /////////////////////////////////////////////////////////////////////////////
// Retainer cup

module cup_sideplate() {
  support_d = width-depth;
  support_r = support_d/2;

  difference() {
    translate([0, 0, 0])
    cube([depth, width*2, width/2]);

    translate([-1, support_d+width, support_r+depth])
    rotate([0, 90, 0])
    scale([1, 2, 1])
    cylinder(d=support_d, h=depth+2);
  }
}

module cup_body() {
  translate([width/2, width, width/2])
  rotate([90, 0, 0])
  cylinder(d=width, h=width);
}

module cup_cutout() {
  translate([width/2, width*2+depth, width/2])
  rotate([90, 0, 0])
  cylinder(d=width-depth, h=width*2);
}

// /////////////////////////////////////////////////////////////////////////////
// Housing holder

module housing_holder() {
  backplate();
  difference() {
    union() {
      cup_body();

      cup_sideplate();

      translate([width-depth, 0, 0])
      cup_sideplate();
    }
    cup_cutout();
  }
}

rotate([90, 0, 0])
housing_holder();
