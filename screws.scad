
module screw_hole(
    length,
    r       = 4.5/2,
    head_od = 8.7,
    head_id = 4.0,
    head_h  = 3) {

  cylinder(r=r, h=length);
  cylinder(r1=head_od/2, r2=head_id/2, h=head_h);
}
