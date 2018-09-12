
module linear_support(y, z, d, w) {
  points = [
    [  0,  0,  0   ], // 0
    [  w,  0,  0   ], // 1
    [  w,  d,  0   ], // 2
    [  0,  d,  0   ], // 3
    [  0,  y,  z   ], // 4
    [  w,  y,  z   ], // 5
    [  w,  y,  z-d ], // 6
    [  0,  y,  z-d ]  // 7
  ];

  polyhedron(points, [
    [0,1,2,3], // bottom
    [4,5,1,0], // front
    [7,6,5,4], // top
    [5,6,2,1], // right
    [6,7,3,2], // back
    [7,4,0,3]  // left
  ]);
}
