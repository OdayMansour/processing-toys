class Node {

  int x, y;
  
  Node(int x, int y) {
    this.x = x;
    this.y = y;
  }

}

  int sizeX = 1200;
  int sizeY = 1200;
  
  int numX = 80;
  int numY = 80;
  
  float offsetX = (float)sizeX / ((float)(numX + 1));
  float offsetY = (float)sizeY / ((float)(numY + 1));
  
  float radius = 1;
  
  Node[][] nodes = new Node[numX][numY];

void setup() {
  
  size(1200, 1200);
  background(0);
  frameRate(30);
  
  println(offsetX);
  println(offsetY);
  
  for (int x=0; x<numX; x++) {
    for (int y=0; y<numY; y++) {
      nodes[x][y] = new Node(x,y);
    }
  }
  
}

void draw() {
  
  background(0);
  
  float noiseVal = 0;
  
  noStroke();
  
  for (int x=0; x<numX; x++) {
    for (int y=0; y<numY; y++) {
      
      noiseVal = noise(x/30.0 + frameCount/300.0, y/30.0 + frameCount/100.0, frameCount/300.0);
      
      fill(noiseVal*255, 0, 127 + 128*noiseVal);
      radius = max(1,noiseVal * 14.0 - 3);
      
      ellipse( (nodes[x][y].x + 1)*offsetX, (nodes[x][y].y + 1)*offsetY, radius, radius);
      
    }
  }
  
  println(frameRate);
}
