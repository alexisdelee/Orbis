void importWorld(String filename) {
  BufferedReader input = createReader("exports/" + filename + ".world");
  try {
    String[] dimensions = input.readLine().split(";");
    W = Integer.parseInt(dimensions[0]);
    H = Integer.parseInt(dimensions[1]);
    D = Integer.parseInt(dimensions[2]);
    int i;

    color[] colors = new color[6];
    for (i = 0; i < 6; i++) {
      if (initial == "B") colors[i] = color(227 / 3.6, saturation, 83);
      else colors[i] = color(347 / 3.6, saturation, 65);
    }
    
    i = 0;
    world = new Cell[D][H][W];
    cells = new int[D][H][W];
    String[] states = input.readLine().split(",");
    for (int x = 0; x < W; x++) {
      for (int y = 0; y < H; y++) {
        for (int z = 0; z < D; z++) {
          cells[z][y][x] = Integer.parseInt(states[i]);
          world[z][y][x] = new Cell((cells[z][y][x] == 1), colors);
          i++;
        }
      }
    }
    
    nextWorld = "";
    String line = input.readLine();
    while (line != null) {
      String[] split = line.split("=");
      split[0] = split[0].trim();
      split[1] = split[1].trim();
      
      if (split[0].equals("nextWorld")) {
        nextWorld = split[1];
      } else if (split[0].equals("duration")) {
        worldDuration = Integer.parseInt(split[1]);
      }
      
      line = input.readLine();
    }

    input.close();
    iterations = 0;
  } 
  catch (IOException ioe) {
    ioe.printStackTrace();
    println("Failed to import \"" + filename + "\".world.");
  }
}