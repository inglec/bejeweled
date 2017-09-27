class Match {
  int x, y;

  Match(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void destroy() {
    int index;  //Current square.

    //Destroy left matches.
    index = x-1;
    while ((index >= 0) && (grid[x][y].fill == grid[index][y].fill)) {
      grid[index][y].isDestroyed = true;
      score += 100;
      index--;  //Move left to next square.
    }

    //Destroy right matches.
    index = x+1;
    while ((index < GRID_WIDTH) && (grid[x][y].fill == grid[index][y].fill)) {
      grid[index][y].isDestroyed = true;
      score += 100;
      index++;  //Move right to next square.
    }

    //Destroy above matches.
    index = y-1;
    while ((index >= 0) && (grid[x][y].fill == grid[x][index].fill)) {
      grid[x][index].isDestroyed = true;
      score += 100;
      index--;  //Move up to next square.
    }

    //Destroy below matches.
    index = y+1;
    while ((index < GRID_HEIGHT) && (grid[x][y].fill == grid[x][index].fill)) {
      grid[x][index].isDestroyed = true;
      score += 100;
      index++;  //Move down to next square.
    }


    //Destroy this Square.
    grid[x][y].isDestroyed = true;
  }
}