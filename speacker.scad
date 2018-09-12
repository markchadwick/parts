
// 80 x 30 x 20
module base() {
  hull() {
    for(x = [-40, 40]) {
      for(y = [-15, 15]) {
        for(z = [-10, 10]) {
          translate([x, y, z])
          sphere(2);
        }
      }
    }
  }
}

module base_with_speakers() {
  difference() {
    base();
  
    mirror([0, 1, 0])
    translate([25, -18, 0])
    sphere(8);
    
    translate([25, -18, 0])
    sphere(8);
  }
}


difference() {
  base_with_speakers();

  difference() {
    translate([30, 0, -12])
    cube([14, 20, 2], center=true);

    translate([22, 7, -12])
    rotate(45)
    cube([5, 5, 1]);
  }
}

