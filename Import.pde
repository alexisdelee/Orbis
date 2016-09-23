void importWorld(String filename) {
  worldName = filename;
  BufferedReader input = createReader("worlds/" + filename + ".world");
  try {
    String[] dimensions = input.readLine().split(";");
    W = Integer.parseInt(dimensions[0]);
    H = Integer.parseInt(dimensions[1]);
    D = Integer.parseInt(dimensions[2]);
    int i;
    
    i = 0;
    world = new Cell[D][H][W];
    cells = new int[D][H][W];
    maxLength = 0.0f;
    cellsAlive = 0;
    String[] states = input.readLine().split(",");
    for (int x = 0; x < W; x++) {
      for (int y = 0; y < H; y++) {
        for (int z = 0; z < D; z++) {
          cells[z][y][x] = Integer.parseInt(states[i]);
          world[z][y][x] = new Cell((cells[z][y][x] == 1), color(currentColor[0], currentColor[1], currentColor[2]), sqrt(pow(W / 2 - x, 2) + pow(H / 2 - y, 2) + pow(D / 2 - z, 2)));
          if (world[z][y][x].distanceFromOrigin > maxLength) maxLength = world[z][y][x].distanceFromOrigin;
          i++;
          if (world[z][y][x].alive) cellsAlive++;
        }
      }
    }
    
    for (int x = 0; x < W; x++) {
      for (int y = 0; y < H; y++) {
        for (int z = 0; z < D; z++) {
          world[z][y][x].c = color(currentColor[0], 10 + 90 * world[z][y][x].distanceFromOrigin / maxLength, currentColor[2]);
        }
      }
    }
    
    nextWorld = "";
    worldDuration = -1;
    addRandomEntity = false;
    String line = input.readLine();
    while (line != null) {
      String[] split = line.split("=");
      split[0] = split[0].trim();
      split[1] = split[1].trim();
      if (split[0].charAt(0) == '#') {
        line = input.readLine();
        continue;
      }
      
      if (split[0].equals("nextWorld")) {
        nextWorld = split[1];
      } else if (split[0].equals("duration")) {
        if (split[1].equals("auto")) worldDuration = -2; 
        else worldDuration = Integer.parseInt(split[1]);
      } else if (split[0].equals("cameraDistance")) {
        cameraDistance = Float.parseFloat(split[1]);
      } else if (split[0].equals("random")) {
        if (split[1].equals("true") || split[1].equals("1")) addRandomEntity = true;
      }
      
      line = input.readLine();
    }
    if (addRandomEntity) {
      if (worldDuration != -1 && worldDuration > 5) {
        randomEntityGeneration = Math.round(random(3, worldDuration - 5));
      } else {
        randomEntityGeneration = Math.round(random(3, 16));
      }
    }

    input.close();
    iterations = 0;
  } 
  catch (IOException ioe) {
    ioe.printStackTrace();
    println("Failed to import \"" + filename + "\".world.");
  }
}