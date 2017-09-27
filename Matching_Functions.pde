boolean isSolvable() {
  //Duplicate array for solving
  Square[][] copy = new Square[GRID_WIDTH][GRID_HEIGHT];
  for (int i = 0; i < GRID_WIDTH; i++) {
    for (int j = 0; j < GRID_HEIGHT; j++) {
      copy[i][j] = grid[i][j];
    }
  }

  for (int i = 0; i < GRID_WIDTH; i++) {
    for (int j = 0; j < GRID_HEIGHT; j++) {
      if (i > 0) {
        softSwap(copy, i, j, i-1, j);  //Swap left
        if (getMatch(copy) != null) {
          return true;
        }
        softSwap(copy, i, j, i-1, j);  //Swap back
      }
      if (i < GRID_WIDTH-1) {
        softSwap(copy, i, j, i+1, j);  //Swap right
        if (getMatch(copy) != null) {
          return true;
        }
        softSwap(copy, i, j, i+1, j);  //Swap back
      }
      if (i > 0) {
        softSwap(copy, i, j, i, j-1);  //Swap above
        if (getMatch(copy) != null) {
          return true;
        }
        softSwap(copy, i, j, i, j-1);  //Swap back
      }
      if (i < GRID_HEIGHT-1) {
        softSwap(copy, i, j, i, j+1);  //Swap below
        if (getMatch(copy) != null) {
          return true;
        }
        softSwap(copy, i, j, i, j+1);  //Swap back
      }
    }
  }

  return false;
}

void softSwap(Square[][] array, int x1, int y1, int x2, int y2) {
  Square temp = array[x1][y1];
  array[x1][y1] = array[x2][y2];
  array[x2][y2] = temp;
}

Match getMatch(Square[][] array) {
  for (int i = 0; i < GRID_WIDTH; i++) {
    for (int j = 0; j < GRID_HEIGHT; j++) {
      if (array[i][j].fill != DEFAULT) {
        int matchesLeft = matchesLeft(array, i, j);
        int matchesRight = matchesRight(array, i, j);
        int matchesX = matchesLeft + matchesRight + 1;

        int matchesUp = matchesUp(array, i, j);
        int matchesDown = matchesDown(array, i, j);
        int matchesY = matchesUp + matchesDown + 1;
        
        if (matchesX >= 3 || matchesY >= 3) {
          return new Match(i, j);
        }
      }
    }
  }
  return null;
}

int matchesLeft(Square[][] array, int x, int y) {
  int matches = 0;
  int i = x-1;  //Check first square on left.

  while ((i > 0) && (array[x][y].fill == array[i][y].fill)) {
    if (array[i][y].isDestroyed == false) {
      matches++;
    }
    i--;  //Move left to next square.
  }
  return matches;
}

int matchesRight(Square[][] array, int x, int y) {
  int matches = 0;
  int i = x+1;  //Check first square on right.

  while ((i < GRID_WIDTH-1) && (array[x][y].fill == array[i][y].fill)) {
    if (array[i][y].isDestroyed == false) {
      matches++;
    }
    i++;  //Move right to next square.
  }
  return matches;
}

int matchesUp(Square[][] array, int x, int y) {
  int matches = 0;
  int j = y-1;  //Check first square above.

  while ((j > 0) && (array[x][y].fill == array[x][j].fill)) {
    if (array[x][j].isDestroyed == false) {
      matches++;
    }
    j--;  //Move up to next square.
  }
  return matches;
}

int matchesDown(Square[][] array, int x, int y) {
  int matches = 0;
  int j = y+1;  //Check first square below.

  while ((j < GRID_HEIGHT-1) && (array[x][y].fill == array[x][j].fill)) {
    if (array[x][j].isDestroyed == false) {
      matches++;
    }
    j++;  //Move down to next square.
  }
  return matches;
}