void exportWorld(String filename) {
  D = cells.length;
  H = cells[0].length;
  W = cells[0][0].length;
  
  PrintWriter output = createWriter("worlds/" + filename + ".world");
  output.println(W + ";" + H + ";" + D);
  
  for (int x = 0; x < W; x++) {
    for (int y = 0; y < H; y++) {
      for (int z = 0; z < D; z++) {
        output.print(cells[z][y][x]);
        if (!(x == W - 1 && y == H - 1 && z == D - 1)) output.print(',');
      }
    }
  }
  
  output.flush();
  output.close();
  println("Exported \"" + filename + "\".world.");
}