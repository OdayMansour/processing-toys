import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer player;
FFT fft_r;
FFT fft_l;

float darkness = 5.0;
float scale = 3000; // Set same as canvas size

// Change these according to song you're painting
// Will be used to calculate rotation speed
float song_minutes = 8;
float song_seconds = 18;

// Number of frames needed for a full rotation
float timescale = (30 * (song_minutes * 60 + song_seconds));

PGraphics pg;

void setup()
{
  // Define canvas params
  size(1500, 1500);
  pg = createGraphics(3000, 3000);
  frameRate(30);
  background(255);

  // Change audio file here
  minim = new Minim(this);
  player = minim.loadFile("../mp3/says.mp3", 2048);
  
  player.loop();

  fft_r = new FFT( player.bufferSize(), player.sampleRate() );
  fft_l = new FFT( player.bufferSize(), player.sampleRate() );
}

void draw()
{
  background(255);
  pg.beginDraw();
  pg.noStroke();
  
  fft_r.forward( player.right );
  fft_l.forward( player.left );
  
  // Start transformation matrix
  pg.pushMatrix();
  
  // Move origin to the center of the screen
  // Then rotate the canvas, rotation speed scaled to song length
  pg.translate(scale/2.0,scale/2.0);
  pg.rotate(frameCount/timescale*2.0*PI - PI/2.0);
  
  // Move origin again a quarter screen to the right (outer ring)
  pg.translate(scale/4.0,0);

  for (int i=0; i<fft_r.specSize()/2; i++) {
    // Set fill color to black, opacity proportional to amplitude at frequency band
    // Then draw 1x2 px rectangle at band position (scaled by 2)
    pg.fill(0,0,0,fft_r.getBand(i)*darkness); 
    pg.rect(i, 0, 1, 1);
  }
  
  // Invert X axis to draw inner ring
  pg.scale(-1,1);
  
  for (int i=0; i<fft_l.specSize()/2; i++) {
    pg.fill(0,0,0,fft_l.getBand(i)*darkness);
    pg.rect(i, 0, 1, 1);
  }

  pg.popMatrix();
  pg.endDraw();
  // Reset transformation matrix
  
  // Save frame once full rotation done
  if (frameCount == timescale) { 
    //saveFrame("says.png");
    pg.save("says.png");
  }
  
  image(pg,-width/2,-height/2);//,width,height);
  
  if (frameCount % 30 == 0) {
    println(frameRate);
  }

}
