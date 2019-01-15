import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer player;
FFT fft_r;
FFT fft_l;

float darkness = 4.0;
float scale = 3000; // Set same as image size

// Change these according to song you're painting
// Will be used to calculate rotation speed
float song_minutes = 4;
float song_seconds = 7;

// Number of frames needed for a full rotation
float timescale = (30 * (song_minutes * 60 + song_seconds));

PGraphics pg;

void setup()
{
  // Define canvas params
  fullScreen();
  //size(1500,1500);
  pg = createGraphics(3000, 3000);
  frameRate(30);
  background(255);

  // Change audio file here
  minim = new Minim(this);
  player = minim.loadFile("../mp3/electrickery.mp3", 2048);
  
  player.play();

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
  
  float barsize = 0;
  float position = 0;
  float j = 0;
  float maxj = fft_r.specSize()/2;

  for (int i=0; i<fft_r.specSize()/2; i++) {
    // Set fill color to black, opacity proportional to amplitude at frequency band
    // Then draw a (scaled) ellipse at band position
    // ellipse size depends on the band position
    // bands near the center (bass) are very crowded
    // I went with an i^0.7 scaling function to emphasize low freqs but keep high freqs smaller and sharper
    pg.fill(0,0,0,fft_r.getBand(i)*darkness);
    
    j = i+1;
    barsize = pow((j+1)/maxj,0.7)*maxj - pow(j/maxj,0.7)*maxj; 
    
    pg.ellipse(position, 0, barsize, 1);
    position = position + barsize;
  }
  
  position = 0;
  
  // Invert X axis to draw inner ring
  pg.scale(-1,1);
  
  for (int i=0; i<fft_l.specSize()/2; i++) {
    pg.fill(0,0,0,fft_l.getBand(i)*darkness);
    
    j = i+1;
    barsize = pow((j+1)/maxj,0.7)*maxj - pow(j/maxj,0.7)*maxj; 
    
    pg.ellipse(position, 0, barsize, 1);
    position = position + barsize;
  }

  pg.popMatrix();
  pg.endDraw();
  // Reset transformation matrix
  
  // Save frame once full rotation done
  if (frameCount == timescale) { 
    pg.save("electrickery.png");
    exit();
  }
  
  image(pg,(width-scale)/2,(height-scale)/2);//,width,height);
  
  if (frameCount % 30 == 0) {
    println(frameRate);
  }

}
