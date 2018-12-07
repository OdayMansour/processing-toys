class Node {

  int x, y;
  float realX, realY;
  
  Node(int x, int y, float realX, float realY) {
    this.x = x;
    this.y = y;
    this.realX = realX;
    this.realY = realY;
  }
  
}

class Grid {
  int sizeX, sizeY;
  int numX, numY;
  float offsetX, offsetY;
  float radius;
  
  Node[][] nodes;
  
  Grid() {
    this.sizeX = 1200;
    this.sizeY = 1200;
    
    this.numX = 80;
    this.numY = 80;
    
    this.offsetX = (float)sizeX / ((float)(numX + 1));
    this.offsetY = (float)sizeY / ((float)(numY + 1));
    
    this.radius = 1;
    
    this.nodes = new Node[numX][numY];
    
    float realX, realY = 0;
    for (int x=0; x<numX; x++) {
      for (int y=0; y<numY; y++) {
        realX = (x+1)*offsetX;
        realY = (y+1)*offsetY;
        this.nodes[x][y] = new Node(x,y,realX,realY);
      }
    }
  }
    
  void drawGrid(int greycolor) {
    
    if (greycolor == -1) {
      noFill();
    } else {
      fill(greycolor);
    }
    
    noStroke();
    
    for (int x=0; x<numX; x++) {
      for (int y=0; y<numY; y++) {
        ellipse( (nodes[x][y].x + 1)*offsetX, (nodes[x][y].y + 1)*offsetY, radius, radius); //<>//
      }
    }
  }
  
}

Grid grid;

void setup() {
  size(1200, 1200);
  background(0);
  frameRate(1);
  
  grid = new Grid();
  
  println(grid.offsetX);
  println(grid.offsetY);
}

void draw() {
  
  background(255);
  
  grid.drawGrid(-1);
  
  Node tl, tr, br, bl;
  for (int x=0; x<(grid.numX-1); x++) {
    for (int y=0; y<(grid.numY-1); y++) {
      tl = grid.nodes[x][y];
      tr = grid.nodes[x+1][y];
      br = grid.nodes[x+1][y+1];
      bl = grid.nodes[x][y+1];
      
      stroke(0);
      drawCell(tl, tr, br, bl);
      
    }
  }
  
  println(frameRate);
}

void drawCell(Node tl, Node tr, Node br, Node bl) {
  int pick = floor(random(0,7));
  
  switch (pick) {
    case 0:
      line(tl, tr);
      break;
    case 1:
      line(tr, br);
      break;
    case 2:
      line(br, bl);
      break;
    case 3:
      line(bl, tl);
      break;
    case 4:
      line(tl, br);
      break;
    case 5:
      line(tr, bl);
      break;
  }
}

void line(Node node1, Node node2) {
  line(node1.realX, node1.realY, node2.realX, node2.realY);
}
