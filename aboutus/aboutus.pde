import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;

final int scale = 1;

float x, y;

float xStep = scale * 10.0;
float yStep = scale * 36.0;

void setup() {
  size(1000,1000, P3D);
  background(255);
  noFill();
  
  frameRate(30);

  minim = new Minim(this);

  player = minim.loadFile("si.mp3", 2*1024);
  player.loop();
  
  x = yStep; 
  y = yStep;
  
}

void draw() {
    
  float level = player.left.level();
  float size = 2 * min(50,max(3, pow(6, level*6)+level*40));
  
  stroke(0, 0, 0, max(20, level*500));
  ellipse(x, y, size, size);
  
  x += xStep;
  
  if (x >= width - yStep) {
    y += yStep;
    x = yStep;
  }
 
}
