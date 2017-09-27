final int SCREEN_WIDTH = 700, SCREEN_HEIGHT = 700;
final int OFFSET = 100;
final int GRID_WIDTH = 10, GRID_HEIGHT = 11;
final int SQUARE_SIZE = 50;
final float ANIMATION_SPEED = 8, DEGENERATION_SPEED = 2;
final int NUMBER_OF_COLOURS = 6;
final color DEFAULT = color(0), CLICKED = color(255);

color[] colours;
Square[][] grid;
Square clicked[];
boolean swapping = false;
int score = 0;
int displayScore = 0;

PImage space;

void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
  clicked = new Square[2];
  
  space = loadImage("maxresdefault.jpg");
  space.resize((int)(space.width*0.7), (int)(space.height*0.7));
  imageMode(CENTER);

  //Put colours in array.
  colours = new color[NUMBER_OF_COLOURS];
  colours[0] = color(255, 0, 0);   //Red
  colours[1] = color(0, 255, 0);   //Green
  colours[2] = color(0, 0, 255);   //Blue
  colours[3] = color(255, 255, 0); //Yellow
  colours[4] = color(255, 0, 255); //Magenta
  colours[5] = color(0, 255, 255); //Cyan

  //Create grid of squares.
  grid = new Square[GRID_WIDTH][GRID_HEIGHT];
  for (int i = 0; i < GRID_WIDTH; i++) {
    for (int j = 0; j < GRID_HEIGHT; j++) {
      grid[i][j] = new Square(i, j, OFFSET, OFFSET, SQUARE_SIZE, SQUARE_SIZE);
    }
  }

  //Set colour of squares.
  do {
    for (int i = 0; i < GRID_WIDTH; i++) {
      for (int j = 0; j < GRID_HEIGHT; j++) {
        //Set colour of square to make no matches.
        do {
          grid[i][j].fill = colours[(int)random(colours.length)];
        } while (getMatch(grid) != null);  //Repeat until no matches exist on grid.
      }
    }
  } while (!isSolvable());

  strokeWeight(2);
}

void draw() {
  image(space, width/2, height/2);
  
  if (displayScore < score) {
    displayScore += 10;
  }
  
  fill(255);
  textSize(30);
  text(displayScore, 50, 50);

  //Clear board of any matches.
  if (animationsComplete() == true) {
    Match match = getMatch(grid);

    if (swapping == true) {
      //If swap creates no match, swap back.
      if (match == null) {
        swap(clicked[0], clicked[1]);
      }
      clicked[0].stroke = DEFAULT;
      clicked[1].stroke = DEFAULT;
      clicked = new Square[2];
      
      swapping = false;
    }

    while (match != null) {
      match.destroy();
      match = getMatch(grid);
    }

    clearDestroyedSquares();
    dropSquares();
  }

  //Animate and draw all squares.
  for (int i = 0; i < GRID_WIDTH; i++) {
    for (int j = 0; j < GRID_HEIGHT; j++) {
      grid[i][j].animate();
      grid[i][j].display();
    }
  }
}

void dropSquares() {
  for (int x = 0; x < GRID_WIDTH; x++) {
    for (int y = 0; y < GRID_HEIGHT; y++) {
      if (grid[x][y] == null) {
        for (int i = y; i > 0; i--) {
          //Replace with square above.
          grid[x][i] = grid[x][i-1];
          grid[x][i].setTarget(x, i);
        }

        grid[x][0] = new Square(x, 0, OFFSET, OFFSET, SQUARE_SIZE, SQUARE_SIZE);
        grid[x][0].fill = colours[(int)random(colours.length)];
      }
    }
  }
}

void mousePressed() {
  if (animationsComplete() == true) {
    for (int i = 0; i < GRID_WIDTH; i++) {
      for (int j = 0; j < GRID_HEIGHT; j++) {
        if (grid[i][j].isMouseOver() == true) {
          //If first click.
          if (clicked[0] == null) {
            selectFirst(grid[i][j]);
          } else { //If second click.
            selectSecond(grid[i][j]);
          }
        }
      }
    }
  }
}

void selectFirst(Square square) {
  //Set the clicked square to the new first square.
  clicked[0] = square;
  clicked[0].stroke = CLICKED;
}

void selectSecond(Square square) {
  //Set the clicked square to the new second square.
  clicked[1] = square;

  if (areSwitchable(clicked[0], clicked[1]) == true) {
    //Switch the adjacent squares.
    swap(clicked[0], clicked[1]);
    clicked[0].stroke = DEFAULT;
    clicked[1].stroke = DEFAULT;
    swapping = true;
  } else {
    clicked[0].stroke = DEFAULT;
    selectFirst(square);
  }
}

//Are both squares adjacent, i.e. 1 square apart?
boolean areSwitchable(Square one, Square two) { 
  if (abs(one.col - two.col) == 1 && abs(one.row - two.row) == 0) {
    return true;
  } else if (abs(one.row - two.row) == 1 && abs(one.col - two.col) == 0) {
    return true;
  } else return false;
}

void swap(Square one, Square two) {
  //Swap references in 2D array.
  grid[one.col][one.row] = two;
  grid[two.col][two.row] = one;

  //Swap array indices of one and two.
  one.setTarget(two.col, two.row);
  two.setTarget(one.col, one.row);
}

boolean animationsComplete() {
  for (int i = 0; i < GRID_WIDTH; i++) {
    for (int j = 0; j < GRID_HEIGHT; j++) {
      if (grid[i][j].isAnimating == true) {
        return false;
      }
    }
  }
  return true;
}

void clearDestroyedSquares() {
  for (int i = 0; i < GRID_WIDTH; i++) {
    for (int j = 0; j < GRID_HEIGHT; j++) {
      if (grid[i][j].delete == true) {
        grid[i][j] = null;
      }
    }
  }
}