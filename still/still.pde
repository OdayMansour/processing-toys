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
float scale = 1500;

PFont font;

void setup()
{
  size(1500, 1500);
  frameRate(30);
  background(255);

  minim = new Minim(this);
  player = minim.loadFile("still.mp3", 1024);
  
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
  rotate(frameCount/12480.0*2.0*PI - PI/2.0);
  
  //ellipse(0,0,3,3);
  
  translate(scale/4.0,0);
  scale(-1,1);
  
  //fill(255,0,0);
  
  for (int i=0; i<fft_r.specSize()/2; i++) {
    fill(0,0,0,fft_l.getBand(i)*darkness);
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
  
  if (frameCount == 12480) {
    saveFrame("final.png");
  }

}

void drawSpectrum(FFT fft) {
  
}
