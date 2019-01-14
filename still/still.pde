import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer player;
FFT fft_r;
FFT fft_l;

float darkness = 5.0;
float scale = 1000; // Set same as canvas size

// Change these according to song you're painting
// Will be used to calculate rotation speed
float song_minutes = 3;
float song_seconds = 23;

// Number of frames needed for a full rotation
float timescale = (30 * (song_minutes * 60 + song_seconds));

void setup()
{
  // Define canvas params
  size(1000, 1000);
  frameRate(30);
  background(255);

  // Change audio file here
  minim = new Minim(this);
  player = minim.loadFile("../mp3/si.mp3", 512);
  
  player.loop();

  fft_r = new FFT( player.bufferSize(), player.sampleRate() );
  fft_l = new FFT( player.bufferSize(), player.sampleRate() );
}

void draw()
{
  noStroke();
  
  fft_r.forward( player.right );
  fft_l.forward( player.left );
  
  // Start transformation matrix
  pushMatrix();
  
  // Move origin to the center of the screen
  // Then rotate the canvas, rotation speed scaled to song length
  translate(scale/2.0,scale/2.0);
  rotate(frameCount/timescale*2.0*PI - PI/2.0);
  
  // Move origin again a quarter screen to the right (outer ring)
  translate(scale/4.0,0);

  for (int i=0; i<fft_r.specSize()/2; i++) {
    // Set fill color to black, opacity proportional to amplitude at frequency band
    // Then draw 1x2 px rectangle at band position (scaled by 2)
    fill(0,0,0,fft_r.getBand(i)*darkness); 
    rect(i*2, 0, 2, 1);
  }
  
  // Invert X axis to draw inner ring
  scale(-1,1);
  
  for (int i=0; i<fft_l.specSize()/2; i++) {
    fill(0,0,0,fft_l.getBand(i)*darkness);
    rect(i*2, 0, 2, 1);
  }

  popMatrix();
  // Reset transformation matrix
  
  // Save frame once full rotation done
  if (frameCount == timescale) { 
    saveFrame("si.png");
  }
  
  if (frameCount % 30 == 0) {
    println(frameRate);
  }

}
