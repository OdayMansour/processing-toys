import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;

int scale = 1; // Set to canvas size/1000

// Change step size
float xStep = scale * 10.0;
float yStep = scale * 36.0;

// Globals
float x, y;
int lines = 0;
int circles = 0;

void setup() {
  // Define canvas params
  size(1000,1000);
  frameRate(30);
  background(255);
  
  noFill();

  // Change audio file here
  minim = new Minim(this);
  player = minim.loadFile("../mp3/si.mp3", 2*1024);
  
  player.loop();
  
  // Initial circle location
  x = yStep; 
  y = yStep;
}

void draw() {
  
  // Keep track of max level over the last frames
  float level = player.left.level();
  
  // Circle size depends on sound level
  // Maximum size is 50 pixels (using min function)
  // Minimum size is 3 pixels (using max function)
  // Otherwise size is 35X + 6^(7X) where X = maxlevel
  // This was tuned manually, no logic there.
  float size = 
    scale * 2 * 
      min(
        50,
        max(
          3, 
          pow(6, level*7) + level*35
        )
      );
      
  // Stroke is black, opacity goes from 50/100 to maxlevel*600/100
  stroke(0, 0, 0, max(40, level*600));
  // Stroke width scales in case of large canvas
  strokeWeight(scale);
  // Draw circle
  ellipse(x, y, size, size);

  // Move on to next circle
  circles++;
  x += xStep;

  // Go to next line
  if (x >= (width - yStep + 5) ) {
    lines++;
    y += yStep;
    x = yStep;
  }
  
  if (lines == 27) {
    noLoop();
    saveFrame("final.png");
  }
 
}
