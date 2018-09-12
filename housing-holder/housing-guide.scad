$fn = 50;

width = 35;
depth = 5;

// /////////////////////////////////////////////////////////////////////////////
// Backing plate

module backplate(width, height) {
  screw_r = 4.3/2;
  head_or = 8.2/2;
  head_ir = 3.3/2;
  head_h  = 3;

  difference() {
    cube([width, height, depth]);

    translate([width/2, height-(width/2), -1])
    cylinder(r=screw_r, h=depth+2); 

    translate([width/2, height-(width/2), depth+0.01-head_h])
    cylinder(r1=head_ir, r2=head_or, h=head_h);
  }
}

// /////////////////////////////////////////////////////////////////////////////
// Retainer cup


module cup_body() {
  translate([width/2, width/3, width/2])
  rotate([90, 0, 0])
  cylinder(d=width, h=width/3);
}

module cup_cutout() {
  translate([width/2, width, width/2])
  rotate([90, 0, 0])
  cylinder(d=width-depth, h=width*2);
}

// /////////////////////////////////////////////////////////////////////////////
// Housing holder

module housing_holder() {
  backplate(width, width*2);
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

module guide() {
  backplate(width, width);
  difference() {
    cup_body();
    cup_cutout();
  }
}

// rotate([90, 0, 0])
// housing_holder();

rotate([90, 0, 0])
guide();
