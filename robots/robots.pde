import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer player;
FFT fft_r;
FFT fft_l;

float darkness = 6.0;
float scale = 1500; // Set same as image size

// Change these according to song you're painting
// Will be used to calculate rotation speed
float song_minutes = 20;
float song_seconds = 0;

// Number of frames needed for a full rotation
float timescale = (30 * (song_minutes * 60 + song_seconds));

float[] avg_right = {};
float[] avg_left = {};

int averaging = 1 * 30;

PGraphics pg;

void setup()
{
  // Define canvas params
  // fullScreen();
  size(1500,1500);
  pg = createGraphics(1500, 1500);
  frameRate(30);
  background(255);

  // Change audio file here
  minim = new Minim(this);
  player = minim.loadFile("../mp3/robots.mp3", 1024);
  
  player.play();

  fft_r = new FFT( player.bufferSize(), player.sampleRate() );
  fft_l = new FFT( player.bufferSize(), player.sampleRate() );

  avg_right = new float[player.bufferSize()];
  avg_left = new float[player.bufferSize()];
}

void draw()
{
  background(255);
  pg.beginDraw();
  pg.background(255);
  pg.noFill();
  
  fft_r.forward( player.right );
  fft_l.forward( player.left );
  
  // Start transformation matrix
  pg.pushMatrix();
  
  // Move origin to the center of the screen
  pg.translate(scale/2.0,scale/2.0);
  
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

    avg_right[i] = (avg_right[i] * (averaging-1) + fft_r.getBand(i)) / averaging;

    pg.stroke(0,0,0,avg_right[i]*darkness);
    
    j = i+1;
    barsize = 2.0 * (pow((j+1)/maxj,0.7)*maxj - pow(j/maxj,0.7)*maxj);
    
    pg.rect(position, 0, barsize, -avg_right[i] * sqrt((i+1) / 3.0));
    position = position + barsize;
  }
  
  position = 0;
  
  // Invert X axis to draw inner ring
  pg.scale(-1,1);
  
  for (int i=0; i<fft_l.specSize()/2; i++) {
    
    avg_left[i] = (avg_left[i] * (averaging-1) + fft_r.getBand(i)) / averaging;

    pg.stroke(0,0,0,avg_left[i]*darkness);

    j = i+1;
    barsize = 2.0 * (pow((j+1)/maxj,0.7)*maxj - pow(j/maxj,0.7)*maxj);
    
    pg.rect(position, 0, barsize, -avg_left[i] * sqrt((i+1) / 3.0));
    position = position + barsize;
  }

  pg.popMatrix();
  pg.endDraw();
  // Reset transformation matrix
  
  // Save frame once full rotation done
  if (frameCount == timescale) { 
    // pg.save("electrickery.png");
    exit();
  }
  
   //image(pg,(width-scale)/2,(height-scale)/2);//,width,height);
  image(pg,(width-scale)/2,0);//,width,height);
  
  if (frameCount % 30 == 0) {
    println(frameRate);
  }

}
