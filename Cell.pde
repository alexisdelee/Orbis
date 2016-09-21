public class Cell {
  boolean alive;
  color[] colors;

  public Cell(boolean _alive, color[] _colors) {
    this.alive = _alive;
    this.colors = _colors;
  }

  public color[] getColors() {
    return this.colors;
  }

  public void setUniformColor(color c) {
    for (int i = 0; i < 6; i++) {
      this.colors[i] = c;
    }
  }
}