int[][][] cells;
int W, H, D;
Cell[][][] world;

String nextWorld = "";
int worldDuration = -1;

void setupWorld() {
  importWorld("test2");
  
  color[] colors = new color[6];
  for (int i = 0; i < 6; i++) {
    colors[i] = initialColor;
  }

  for (int x = 0; x < W; x++) {
    for (int y = 0; y < H; y++) {
      for (int z = 0; z < D; z++) {
        world[z][y][x] = new Cell((cells[z][y][x] == 1), colors);
      }
    }
  }
}