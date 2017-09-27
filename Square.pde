class Square {
  int col, row;
  int colTarget, rowTarget;
  float x, y, w, h;
  float xTarget, yTarget;
  float xOffset, yOffset;
  color fill = DEFAULT, stroke = DEFAULT;
  boolean isAnimating = false;
  boolean isDestroyed = false;
  boolean delete = false;

  Square(int col, int row, float xOffset, float yOffset, float w, float h) {
    this.col = col;
    this.row = row;
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    this.w = w;
    this.h = h;
    this.x = xOffset + col*w;
    this.y = -h;  //Start each square off top of screen.

    xTarget = x;
    yTarget = yOffset + row*h;
    colTarget = col;
    rowTarget = row;
  }

  void display() {
    stroke(stroke);
    fill(fill);
    rect(x, y, w, h);
  }

  void animate() {
    if (isDestroyed == true) {
      w -= DEGENERATION_SPEED;
      h -= DEGENERATION_SPEED;
      x += DEGENERATION_SPEED/2;
      y += DEGENERATION_SPEED/2;

      if (w <= 0 && h <= 0) {
        delete = true;
      }
    } else {

      //Set row and column upon reaching target.
      if (x == xTarget && y == yTarget) {
        col = colTarget;
        row = rowTarget;

        isAnimating = false;
      }

      //Stop jittering over target.
      if (abs(xTarget - x) < ANIMATION_SPEED) {
        x = xTarget;
      }
      if (abs(yTarget - y) < ANIMATION_SPEED) {
        y = yTarget;
      }

      //Move towards xTarget.
      if (x > xTarget) {
        x -= ANIMATION_SPEED;
      } else if (x < xTarget) {
        x += ANIMATION_SPEED;
      }
      //Move towards yTarget.
      if (y > yTarget) {
        y -= ANIMATION_SPEED;
      } else if (y < yTarget) {
        y += ANIMATION_SPEED;
      }
    }
  }

  //Calculate (x, y) coords based on array indices.
  void setTarget(int col, int row) {
    //Set target indices.
    colTarget = col;
    rowTarget = row;

    //Calculate target coords.
    xTarget = xOffset + colTarget*w;
    yTarget = yOffset + rowTarget*h;

    isAnimating = true;
  }

  boolean isMouseOver() {
    return ((mouseX > x) && (mouseX < x+w) && (mouseY > y) && (mouseY < y+h));
  }
}