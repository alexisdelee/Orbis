public class Cell {
  boolean alive;
  color c;
  float distanceFromOrigin;

  public Cell(boolean _alive, color _color, float _distance) {
    this.alive = _alive;
    this.c = _color;
    this.distanceFromOrigin = _distance;
  }
}