// $fn = 50;

// /////////////////////////////////////////////////////////////////////////////
// Base

module measure_bar(width, height, depth, chamfer=0) {
  wi = width - (chamfer * 2);
  hi = height - (chamfer * 2);

  text_size  = 7;
  text_with  = 14;

  line_pad     = 3;
  line_height  = 0.5;
  line_width   = (width / 2) - (text_with / 2) - (line_pad * 2);
  line_depth   = 2;
  line_y       = (height / 2) + chamfer - 0.5;
  line_z       = depth - line_depth;

  right_line_x = (text_with / 2) + line_pad;
  left_line_x  = (-width/2) + line_pad;

  difference() {
    linear_extrude(height=depth)
    offset(chamfer, chamfer=true)
    translate([-wi/2, 0])
    square([wi, height]);

    translate([0, 0, -1])
    linear_extrude(height=depth+2)
    offset(-0.15)
    translate([0, (height/2)+1])
    text(
      text   = str(width),
      size   = text_size,
      font   = "Octin Stencil:style=Regular",
      halign = "center",
      valign = "center");

    translate([right_line_x, line_y, line_z])
    cube([line_width, line_height, line_depth+1]);

    translate([left_line_x, line_y, line_z])
    cube([line_width, line_height, line_depth+1]);
  }
}

module measure_bars(spacings, i, bar_height, depth, chamfer) {
  dy = bar_height; //  + (chamfer*2);

  if(i < len(spacings)) {
    translate([0, -dy*(i+1), 0])
    measure_bar(
      width   = spacings[i],
      height  = bar_height,
      depth   = depth,
      chamfer = chamfer);

    measure_bars(
      spacings   = spacings,
      i          = i+1,
      bar_height = bar_height,
      depth      = depth,
      chamfer    = chamfer);
  }
}

// /////////////////////////////////////////////////////////////////////////////
// Handle


module handle_neg(spacings, depth, bar_height, pin_radius) {
  offset_y = (len(spacings) * bar_height) + 1;

  // Peg hole, 7mm
  translate([0, -offset_y, -1])
  cylinder(r=pin_radius, h=depth+2);
}

module handle(spacings, depth, bar_height, pin_radius) {
  offset_y  = (len(spacings) * bar_height) + 1;
  thickness = 3;
  handle_r  = pin_radius + thickness;

  difference() {
    // Outer handle knob
    translate([0, -offset_y, 0])
    cylinder(r=handle_r, h=depth);

    // Clip top of handle circle
    translate([-handle_r, -offset_y+1, -1])
    cube([handle_r*2, 10, depth+2]);
  }
}

// /////////////////////////////////////////////////////////////////////////////
// Spacer

module spacer(spacings, bar_height, depth, chamfer, pin_radius) {
  difference() {

    union() {
      measure_bars(
        spacings   = spacings,
        i          = 0,
        bar_height = bar_height,
        depth      = depth,
        chamfer    = chamfer);

      handle(
        spacings   = spacings,
        depth      = depth,
        bar_height = bar_height,
        pin_radius = pin_radius);
    }

    handle_neg(
      spacings   = spacings,
      depth      = depth,
      bar_height = bar_height,
      pin_radius = pin_radius);
  }
}

// /////////////////////////////////////////////////////////////////////////////
// Main

spacer(
  spacings     = [100, 120, 126, 130, 135],
  bar_height   = 13,
  depth        = 4,
  chamfer      = 1,
  pin_radius   = 3.5);
