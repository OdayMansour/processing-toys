static abstract class Connection {
  static final int UP = 0;
  static final int RIGHT = 1;
  static final int DOWN = 2;
  static final int LEFT = 3;
}

class Point {
  float x, y;

  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class Scene {
  int X_real, Y_real;
  float X_tile_size, Y_tile_size;

  Scene(int X_real, int Y_real, float X_tile_size, float Y_tile_size) {
    this.X_real = X_real;
    this.Y_real = Y_real;
    this.X_tile_size = X_tile_size;
    this.Y_tile_size = Y_tile_size;
  }
}

class Tile {

  // coordinates
  int x, y;
  boolean[] connections;
  color col;

  // real coordinates on screen (center of tile)
  float x_real, y_real;

  Tile(int x, int y, Scene scene) {
    this.x = x;
    this.y = y;
    
    this.col = color(0,0,0);

    this.connections = new boolean[4];

    x_real = (x+0.5)*scene.X_tile_size;
    y_real = (y+0.5)*scene.Y_tile_size;
  }
}

void line(Point a, Point b) {
  line(a.x, a.y, b.x, b.y);
}

void quad(Point a, Point b, Point c, Point d) {
  quad(a.x, a.y, b.x, b.y, c.x, c.y, d.x, d.y);
}

class Grid {

  int X, Y;
  Scene scene;
  int cursor_x, cursor_y;

  Tile[][] tiles;

  Grid(int X, int Y, int X_real, int Y_real) {

    this.scene = new Scene(X_real, Y_real, X_real/(float)X, Y_real/(float)Y);
    this.X = X;
    this.Y = Y;
    
    this.cursor_x = X/2;
    this.cursor_y = Y/2;

    this.tiles = new Tile[X][Y];
    this.initializeTiles();
  }
  
  void initializeTiles() {
    for (int x=0; x<X; x++) {
      for (int y=0; y<Y; y++) {
        this.tiles[x][y] = new Tile(x, y, scene);
      }
    }
  }

  boolean walkAndDraw(int steps, float hue) {
    
    int step = 0;
    
    while (step < steps) {
      int door = floor(random(0,4));
    
      if (door == Connection.UP) {
        cursor_y -= 1;
      } else if (door == Connection.RIGHT) {
        cursor_x += 1;
      } else if (door == Connection.DOWN) {
        cursor_y += 1;
      } else if (door == Connection.LEFT) {
        cursor_x -= 1;
      }
     
      if ( (cursor_x >= 0) && (cursor_x < X) && (cursor_y >= 0) && (cursor_y < Y) ) {
        
        tiles[cursor_x][cursor_y].connections[door] = true;
        tiles[cursor_x][cursor_y].col = color(hue, 100, 100);
        
        noStroke();
        fill(tiles[cursor_x][cursor_y].col);
        quad(
          tiles[cursor_x][cursor_y].x_real - scene.X_tile_size/2.0,
          tiles[cursor_x][cursor_y].y_real - scene.Y_tile_size/2.0,
          tiles[cursor_x][cursor_y].x_real - scene.X_tile_size/2.0,
          tiles[cursor_x][cursor_y].y_real + scene.Y_tile_size/2.0,
          tiles[cursor_x][cursor_y].x_real + scene.X_tile_size/2.0,
          tiles[cursor_x][cursor_y].y_real + scene.Y_tile_size/2.0,
          tiles[cursor_x][cursor_y].x_real + scene.X_tile_size/2.0,
          tiles[cursor_x][cursor_y].y_real - scene.Y_tile_size/2.0
        );
        //return true;
      } else {
        cursor_x = X/2;
        cursor_y = Y/2;
        //return false;
      }
      
      step++;
    }
    
    return true;
    
  }

  void drawGrid() {

    noFill();
    stroke(0);

    Point tl = new Point(0, 0);
    Point tr = new Point(0, 0);
    Point br = new Point(0, 0);
    Point bl = new Point(0, 0);

    for (int x=0; x<X; x++) {
      for (int y=0; y<Y; y++) {

        // Setting corners: topleft, topright, bottomright, bottomleft
        tl.x = tiles[x][y].x_real - scene.X_tile_size/2.0;
        tl.y = tiles[x][y].y_real - scene.Y_tile_size/2.0;
        tr.x = tiles[x][y].x_real - scene.X_tile_size/2.0;
        tr.y = tiles[x][y].y_real + scene.Y_tile_size/2.0;
        br.x = tiles[x][y].x_real + scene.X_tile_size/2.0;
        br.y = tiles[x][y].y_real + scene.Y_tile_size/2.0;
        bl.x = tiles[x][y].x_real + scene.X_tile_size/2.0;
        bl.y = tiles[x][y].y_real - scene.Y_tile_size/2.0;
        
        fill(tiles[x][y].col);
        quad(tl, tr, br, bl);

      }
    }
  }
}

Grid grid;
float i = 0;

void setup() {

  size(1200, 1200);
  colorMode(HSB, 100);
  background(color(0));
  frameRate(1000);

  grid = new Grid(400, 400, 1200, 1200);
}

void draw() {

  if (i%20 == 0) {
    fill(color(0,0,0,0.8));
    noStroke();
    quad(0,0,1200,0,1200,1200,0,1200);
  }
  grid.walkAndDraw(50, (i/5.0)%100);
  i++;
  println(frameRate);
  
}
