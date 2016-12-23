import java.util.Arrays;

PVector origin; // Origin from where the cubes are drawn
PVector cameraRotation; // Camera rotation around origin point
float cameraDistance = 300.0f; // Camera distance from origin point
float lightsDistance = 1000.0f;
int timerMax = 4;
int timer = timerMax;
boolean debugMode = false;
boolean screenshotMode = false;
int iterations = 0;
int SIZE = 16;

float[] colors = new float[] { 96, 65 };
int colorIndex = 0;
int[] currentColor = new int[] { 0, 0, 96 };

int[] rules = new int[] { 3, 2, 3 };

void setup() {
  fullScreen(P3D);
  // size(600, 600, P3D);
  colorMode(HSB, 100);
  stroke(50, 20);
  noCursor();

  origin = new PVector(width / 2.0, height / 2.0, 0.0);
  cameraRotation = new PVector(-90, -90, 0);
  
  importWorld("x");
}

void draw() {
  background(0);
  pointLight(0, 0, 100, origin.x, origin.y, origin.z);
  
  pointLight(0, 0, 50, origin.x, origin.y, origin.z + lightsDistance);
  pointLight(0, 0, 50, origin.x, origin.y, origin.z - lightsDistance);
  
  pointLight(0, 0, 50, origin.x, origin.y + lightsDistance, origin.z);
  pointLight(0, 0, 50, origin.x, origin.y - lightsDistance, origin.z);
  
  pointLight(0, 0, 50, origin.x + lightsDistance, origin.y, origin.z);
  pointLight(0, 0, 50, origin.x - lightsDistance, origin.y, origin.z);

  { // Camera positioning
    float x, y, z;
    x = cameraDistance * sin(radians(cameraRotation.x)) * cos(radians(cameraRotation.y));
    y = cameraDistance * cos(radians(cameraRotation.x));
    z = cameraDistance * sin(radians(cameraRotation.x)) * sin(radians(cameraRotation.y));
    camera(x + origin.x, y + origin.y, z + origin.z, origin.x, origin.y, origin.z, 0, 1.0, 0);
  }

  if (keyPressed) { // Move camera around origin
    if (keyCode == LEFT) cameraRotation.y += 2;
    else if (keyCode == RIGHT) cameraRotation.y -= 2;

    if (keyCode == UP) cameraRotation.x -= 2;
    else if (keyCode == DOWN) cameraRotation.x += 2;
  }

  for (int x = 0; x < W; x++) {
    for (int y = 0; y < H; y++) {
      for (int z = 0; z < D; z++) {
        Cell cell = world[z][y][x];

        if (cell.alive) cube(SIZE, x * SIZE, y * SIZE, z * SIZE, 0, 0, 0, cell.c);
      }
    }
  }

  if (--timer == 0 && !debugMode) {
    regulation();
    timer = timerMax;
  }
}

void keyReleased() {
  if (debugMode && keyCode == 32) {
    regulation();
  }
}

void regulation() {
  if (screenshotMode) {
    save("screenshots/" + worldName + "/" + iterations + ".png");
  }
  
  iterations++;
  
  Cell[][][] alter_ego = new Cell[D][H][W];
  Cell alter_ego_cell, world_cell;

  for (int x = 0; x < W; x++) {
    for (int y = 0; y < H; y++) {
      for (int z = 0; z < D; z++) {
        world_cell = world[z][y][x];
        alter_ego_cell = new Cell(world_cell.alive, world_cell.c, world_cell.distanceFromOrigin);

        if (!alter_ego_cell.alive) {
          if (birth(x, y, z)) {
            alter_ego_cell.alive = true;
            alter_ego_cell.c = color(currentColor[0], 10 + 90 * alter_ego_cell.distanceFromOrigin / maxLength, currentColor[2]);
            cellsAlive++;
          }
        } else {
          if (death(x, y, z)) {
            alter_ego_cell.alive = false;
            cellsAlive--;
          }
        }
        
        alter_ego[z][y][x] = alter_ego_cell;
      }
    }
  }

  currentColor = colorEvolution();
  
  if (Arrays.equals(world, alter_ego) == true) return;
  
  for (int x = 0; x < W; x++) {
    for (int y = 0; y < H; y++) {
      for (int z = 0; z < D; z++) {
        world[z][y][x] = alter_ego[z][y][x];
      }
    }
  }
  
  if ((worldDuration == iterations || (worldDuration == -2 && cellsAlive == 0)) && nextWorld != "") importWorld(nextWorld);
  
  if (addRandomEntity && iterations == randomEntityGeneration) {
    PVector coordinates;
    int i = 0;
    do {
      coordinates = new PVector((int)random(W - 1), (int)random(H - 1), (int)random(D - 1));
    } while (neighbour((int)coordinates.x, (int)coordinates.y, (int)coordinates.z) != 0 && i++ < W * H * D);
    
    int[] direction;
    do {
      direction = new int[] { 1, 1, 1 };
      direction[(int)random(3)] = 0;
      
      for (i = 0; i < 3; i++) {
        direction[i] *= (int)pow(-1, (int)random(0, 2));
      }
    } while (direction[0] + coordinates.z >= D || direction[1] + coordinates.y >= H || direction[2] + coordinates.x >= W ||
             direction[0] + coordinates.z < 0  || direction[1] + coordinates.y < 0  || direction[2] + coordinates.x < 0);
    
    world[(int)coordinates.z + direction[0]][(int)coordinates.y][(int)coordinates.x].alive = true;
    world[(int)coordinates.z][(int)coordinates.y + direction[1]][(int)coordinates.x].alive = true;
    world[(int)coordinates.z][(int)coordinates.y][(int)coordinates.x + direction[2]].alive = true;
    cellsAlive += 3;
  }
}

int[] colorEvolution(){
  int colorIndexNext = (colorIndex + 1 == colors.length ? 0 : colorIndex + 1);
  
  int hue = currentColor[0];
  if (++hue > 100) hue = 0;
  
  int brightness = abs(currentColor[2] - (int)colors[colorIndexNext]);
  int brightnessVariation = (brightness - 1 > 0 ? (currentColor[2] < (int)colors[colorIndexNext] ? 1 : -1) : 0);
  
  if (abs((int)colors[colorIndexNext] - currentColor[2]) == 1) colorIndex = colorIndexNext;
  
  return new int[] { hue, 0, currentColor[2] + brightnessVariation};
};

boolean birth(int x, int y, int z) {
  return neighbour(x, y, z) == rules[0];
}

boolean death(int x, int y, int z) {
  return neighbour(x, y, z) < rules[1] || neighbour(x, y, z) > rules[2];
}

int neighbour(int _x, int _y, int _z) {
  int neighbours = 0;

  for (int x = -1; x <= 1; x++) {
    for (int y = -1; y <= 1; y++) {
      for (int z = -1; z <= 1; z++) {
        if (!(x == 0 && y == 0 && z == 0)) {
          if (_x + x >= 0 && _x + x < W && 
              _y + y >= 0 && _y + y < H && 
              _z + z >= 0 && _z + z < D &&
              world[_z + z][_y + y][_x + x].alive) neighbours++;
        }
      }
    }
  }

  return neighbours;
}

void mouseWheel(MouseEvent event) { // Scroll in or out
  cameraDistance += (event.getCount() == -1 ? -15 : 15);
}

void cube(float size, float x, float y, float z, float rotationX, float rotationY, float rotationZ, color c) {
  translate(origin.x + x - W * SIZE / 2.0, origin.y + y - H * SIZE / 2.0, origin.z + z - D * SIZE / 2.0);
  rotateX(radians(rotationX));
  rotateY(radians(rotationY));
  rotateZ(radians(rotationZ));

  fill(c);
  box(size);
  
  rotateZ(-radians(rotationZ));
  rotateY(-radians(rotationY));
  rotateX(-radians(rotationX));
  translate(-(origin.x + x - W * SIZE / 2.0), -(origin.y + y - H * SIZE / 2.0), -(origin.z + z - D * SIZE / 2.0));
}