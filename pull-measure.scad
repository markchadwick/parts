// $fn = 10;


module handle(w, h, d, r) {
  dia = r * 2;

  translate([r, r, r]) {
    hull() {
      for(x = [0, w-dia]) {
        for(y = [0, h-dia]) {
          for(z = [0, d-dia]) {
            translate([x, y, z]) sphere(r);
            // translate([x, y, z]) cube(r);
          }
        }
      }
    }
  }
}

handle(
  w = 30,
  h = 100,
  d = 10,
  r = 2);
