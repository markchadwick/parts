$fn = 100;

can_d = 65;
can_h = 122;

inch = 25.5;

tray_h = 8 * inch;
tray_w = 6 * inch;
tray_d = 4;

wall_height = 0.8 * inch; 
y_offset = -2.25 * inch;


holder_id = 75;
holder_od = holder_id + (tray_d * 2);
holder_h  = can_h / 2; // TODO: Worse case


module cupholder() {
  // /////////////////////////////////////////////////////////////////////////////
  // Can
  // translate([0, 0, tray_d])
  // %cylinder(d=can_d, h=can_h);
  
  // /////////////////////////////////////////////////////////////////////////////
  // Tray
  difference() {
    color("red")
    translate([-(tray_w/2), y_offset, 0])
    cube([tray_w, tray_h, tray_d]);
    
    translate([0, 0, -1])
    cylinder(d=holder_id, h=tray_d+2);
  }
  
  // /////////////////////////////////////////////////////////////////////////////
  // Walls
  
  // North Wall
  translate([-(tray_w/2), tray_h+y_offset, 0])
  cube([tray_w, tray_d, wall_height]);
  
  // East Wall
  translate([(tray_w/2)-tray_d, y_offset+tray_d, 0])
  cube([tray_d, tray_h, wall_height]);
  
  // South Wall
  translate([-tray_w/2, y_offset, 0])
  cube([tray_w, tray_d, wall_height]);
  
  // West Wall
  translate([-tray_w/2, y_offset, 0])
  cube([tray_d, tray_h, wall_height]);
  
  // /////////////////////////////////////////////////////////////////////////////
  // Holder
  difference() {
    inset = wall_height;
  
    color("blue")
    translate([0, 0, -holder_h+inset])
    cylinder(d=holder_od, h=holder_h);
  
    translate([0, 0, -holder_h+tray_d+inset])
    cylinder(d=holder_id, h=holder_h);
  }
}

translate([0, 0, wall_height])
rotate([0, 180, 0])
cupholder();
