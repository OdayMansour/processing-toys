import ddf.minim.analysis.*;
import ddf.minim.*;

class Point {
  float x;
  float y;
}

Minim minim;  
AudioPlayer player;
FFT fft_r;
FFT fft_l;

float spectrumScale = 4;
float darkness = 5.0;
float scale = 3000;

float song_minutes = 4;
float song_seconds = 5;

float timescale = ( 30 * (song_minutes * 60 + song_seconds));

PFont font;

void setup()
{
  size(3000, 3000);
  frameRate(30);
  background(255);

  minim = new Minim(this);
  player = minim.loadFile("raindrops.mp3", 2048);
  
  player.loop();

  fft_r = new FFT( player.bufferSize(), player.sampleRate() );
  fft_l = new FFT( player.bufferSize(), player.sampleRate() );
}

void draw()
{
  
  //background(255);
  noStroke();
  
  fft_r.forward( player.right );
  fft_l.forward( player.left );
  
  fill(0);
  pushMatrix();
  
  translate(scale/2.0,scale/2.0);
  rotate(frameCount/timescale*2.0*PI - PI/2.0);
  
  //ellipse(0,0,3,3);
  
  translate(scale/4.0,0);
  scale(-1,1);
  
  //fill(255,0,0);
  
  for (int i=0; i<fft_r.specSize()/2; i++) {
    fill(0,0,0,fft_r.getBand(i)*darkness);
    rect(i*2, 0, 2, 1);
    //line(i, 0, i, fft_r.getBand(i));
  }
  
  scale(-1,1);
  
  //fill(0,0,255,0);
  
  for (int i=0; i<fft_l.specSize()/2; i++) {
    fill(0,0,0,fft_l.getBand(i)*darkness);
    rect(i*2, 0, 2, 1);
    //line(i, 0, i, fft_r.getBand(i));
  }

  popMatrix();
  
  if (frameCount == timescale) {
    saveFrame("raindrops.png");
  }

}

void drawSpectrum(FFT fft) {
  
}
