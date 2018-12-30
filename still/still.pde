import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer player;
FFT fftLog_r;
FFT fftLog_l;

float spectrumScale = 4;

PFont font;

void setup()
{
  size(1024, 480);
  frameRate(30);

  minim = new Minim(this);
  player = minim.loadFile("still.mp3", 1024);
  
  player.loop();

  fftLog_r = new FFT( player.bufferSize(), player.sampleRate() );
  fftLog_r.logAverages( 22, 5 );
  fftLog_l = new FFT( player.bufferSize(), player.sampleRate() );
  fftLog_l.logAverages( 22, 5 );
}

void draw()
{
  background(0);
  
  textSize( 18 );
 
  float centerFrequency = 0;
  
  fftLog_r.forward( player.right );
  fftLog_l.forward( player.left );

  noFill();
  stroke(255);
  
  beginShape();
  curveVertex(512, height);
  
  for(int i = 0; i < fftLog_r.avgSize(); i++)
  {
    centerFrequency    = fftLog_r.getAverageCenterFrequency(i);
    float averageWidth = fftLog_r.getAverageBandWidth(i);   
    float highFreq = centerFrequency + averageWidth/2;
    
    int xr = 512+(int)(fftLog_r.freqToIndex(highFreq)*1.4);
    
    curveVertex(xr, height - fftLog_r.getAvg(i)*spectrumScale);
  }
  endShape();
  
  stroke(255,0,0);
  beginShape();
  curveVertex(512, height);

  for(int i = 0; i < fftLog_l.avgSize(); i++)
  {
    centerFrequency    = fftLog_l.getAverageCenterFrequency(i);
    float averageWidth = fftLog_l.getAverageBandWidth(i);   
    float lowFreq = centerFrequency - averageWidth/2;
    
    int xl = 512-(int)(fftLog_l.freqToIndex(lowFreq)*1.4);
    
    curveVertex(xl, height - fftLog_l.getAvg(i)*spectrumScale);
  }
  endShape();
  
}
