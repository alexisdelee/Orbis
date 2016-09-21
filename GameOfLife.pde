import java.util.Arrays;

PVector origin; // Origin from where the cubes are drawn
PVector cameraRotation; // Camera rotation around origin point
float cameraDistance = 300.0f; // Camera distance from origin point
float lightsDistance = 1000.0f;
int timerMax = 6;
int timer = timerMax;
boolean debugMode = false;
int iterations = 0;
int SIZE = 15;

color initialColor = color(347 / 3.6, 85, 65);
String initial = "B";
int iteration = 0, saturation = 60;

int[] rules = new int[] { 3, 2, 3 };

void setup() {
  // fullScreen(P3D);
  size(800, 600, P3D);
  colorMode(HSB, 100);
  stroke(50, 20);

  setupWorld();

  origin = new PVector(width / 2.0, height / 2.0, 0.0);
  cameraRotation = new PVector(-90, -90, 0);
}

void draw() {
  background(0);
  //lights();
  pointLight(0, 0, 100, origin.x, origin.y, origin.z);
  //pointLight(0, 0, 100, origin.x, origin.y, origin.z);
  
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

  if (--timer == 0 && !debugMode) {
    regulation();
    timer = timerMax;
  }

  for (int x = 0; x < W; x++) {
    for (int y = 0; y < H; y++) {
      for (int z = 0; z < D; z++) {
        Cell cell = world[z][y][x];

        if (cell.alive) cube(SIZE, x * SIZE, y * SIZE, z * SIZE, 0, 0, 0, cell.getColors());
      }
    }
  }
}

void keyReleased() {
  if (debugMode && keyCode == 32) {
    regulation();
  }
}

void regulation() {
  iterations++;
  
  Cell[][][] alter_ego = new Cell[D][H][W];
  Cell alter_ego_cell, world_cell;

  for (int x = 0; x < W; x++) {
    for (int y = 0; y < H; y++) {
      for (int z = 0; z < D; z++) {
        world_cell = world[z][y][x];
        alter_ego_cell = new Cell(world_cell.alive, world_cell.colors);

        if (!alter_ego_cell.alive) {
          if (birth(x, y, z)) {
            alter_ego_cell.alive = true;
          }
        } else {
          if (death(x, y, z)) {
            alter_ego_cell.alive = false;
          }
        }

        if (world_cell != alter_ego_cell) {
          if (alter_ego_cell.alive) {
            if (initial == "B") alter_ego_cell.setUniformColor(color(227 / 3.6, saturation, 83));
            else alter_ego_cell.setUniformColor(color(347 / 3.6, saturation, 65));
          }
        }
        
        alter_ego[z][y][x] = alter_ego_cell;
      }
    }
  }

  if (saturation >= 2 && initial == "B") {
    saturation -= 2;
  } else {
    initial = "R";
    saturation += 2;
  }

  if (Arrays.equals(world, alter_ego) == true) return;
  
  for (int x = 0; x < W; x++) {
    for (int y = 0; y < H; y++) {
      for (int z = 0; z < D; z++) {
        world[z][y][x] = alter_ego[z][y][x];
      }
    }
  }
  
  if (worldDuration == iterations && nextWorld != "") importWorld(nextWorld);
}

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

void cube(float size, float x, float y, float z, float rotationX, float rotationY, float rotationZ, color[] colors) {
  size /= 2;
  translate(origin.x + x - W * SIZE / 2.0, origin.y + y - H * SIZE / 2.0, origin.z + z - D * SIZE / 2.0);
  rotateX(radians(rotationX));
  rotateY(radians(rotationY));
  rotateZ(radians(rotationZ));

  beginShape();
  fill(colors[0]);
  vertex( size, -size, size);
  vertex(-size, -size, size);
  vertex(-size, -size, -size);
  vertex( size, -size, -size);
  endShape(CLOSE);

  beginShape();
  fill(colors[1]);
  vertex( size, size, size);
  vertex(-size, size, size);
  vertex(-size, size, -size);
  vertex( size, size, -size);
  endShape(CLOSE);

  beginShape();
  fill(colors[2]);
  vertex(-size, size, size);
  vertex(-size, size, -size);
  vertex(-size, -size, -size);
  vertex(-size, -size, size);
  endShape(CLOSE);

  beginShape();
  fill(colors[3]);
  vertex(size, size, size);
  vertex(size, size, -size);
  vertex(size, -size, -size);
  vertex(size, -size, size);
  endShape(CLOSE);

  beginShape();
  fill(colors[4]);
  vertex( size, -size, size);
  vertex(-size, -size, size);
  vertex(-size, size, size);
  vertex( size, size, size);
  endShape(CLOSE);

  beginShape();
  fill(colors[5]);
  vertex( size, -size, -size);
  vertex(-size, -size, -size);
  vertex(-size, size, -size);
  vertex( size, size, -size);
  endShape(CLOSE);

  rotateZ(-radians(rotationZ));
  rotateY(-radians(rotationY));
  rotateX(-radians(rotationX));
  translate(-(origin.x + x - W * SIZE / 2.0), -(origin.y + y - H * SIZE / 2.0), -(origin.z + z - D * SIZE / 2.0));
}

// Cube overload
void cube(float size, float x, float y, float z, float rotationX, float rotationY, float rotationZ, color c) {
  color[] colors = new color[6];
  for (int i = 0; i < 6; i++) colors[i] = c;
  cube(size, x, y, z, rotationX, rotationY, rotationZ, colors);
}