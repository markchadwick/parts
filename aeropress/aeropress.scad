
press_lip_od    = 83.3;
press_lip_depth = 4.6;

module hanger_arm(d, id, od) {
  difference() {
    cube([od, od, d]);

    translate([od/2, od/2, -1])
    cylinder(d=id, h=d+2);

    translate([(od-id)/2, 0, -1])
    cube([id, od/2, d+2]);
  }
}

hanger_arm(2, id=62, od=80);
