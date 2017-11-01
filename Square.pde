class Square {
  int col, row;              //Board index of square.
  int colTarget, rowTarget;  //Board destination after animating.
  float x, y, w, h;          //Current location, width and height.
  float xTarget, yTarget;    //Screen destination after animating.
  float xOffset, yOffset;    //Board offset from top-left corner of screen.
  color fill = DEFAULT, stroke = DEFAULT;  //Square colour and outline.
  boolean isAnimating = false;
  boolean isDestroyed = false;
  boolean delete = false;    //Has destroy animation completed?

  /**
   * Square constructor.
   * 
   * Parameters:
   *   col, row = 2D array index of this square.
   *   xOffset, yOffset = How far the board is offset from the top-left corner of the screen.
   *   w, h = Width, Height of square.
   */
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

  /**
   * Show the square on the screen.
   */
  void display() {
    stroke(stroke);
    fill(fill);
    rect(x, y, w, h);
  }

  /**
   *  Move the square from its current position to its destination.
   */
  void animate() {
    if (isDestroyed == true) {
      //Collapse size of square to 0.
      w -= DEGENERATION_SPEED;
      h -= DEGENERATION_SPEED;
      x += DEGENERATION_SPEED/2;
      y += DEGENERATION_SPEED/2;

      //Delete when invisible.
      if (w < 1 && h < 1) {
        delete = true;
      }
    }
    else {
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
      }
      else if (x < xTarget) {
        x += ANIMATION_SPEED;
      }
      //Move towards yTarget.
      if (y > yTarget) {
        y -= ANIMATION_SPEED;
      }
      else if (y < yTarget) {
        y += ANIMATION_SPEED;
      }
    }
  }

  /**
   * Calculate (x, y) coords based on array indices.
   */
  void setTarget(int col, int row) {
    //Set target indices.
    colTarget = col;
    rowTarget = row;

    //Calculate target coords.
    xTarget = xOffset + colTarget*w;
    yTarget = yOffset + rowTarget*h;

    isAnimating = true;
  }

  /**
   * Is the mouse over the square?
   */
  boolean isMouseOver() {
    return ((mouseX > x) && (mouseX < x+w) && (mouseY > y) && (mouseY < y+h));
  }
}