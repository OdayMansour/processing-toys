import ddf.minim.analysis.*;
import ddf.minim.*;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.BufferedInputStream;
import java.io.FileInputStream;

Minim minim;  
AudioPlayer player;
FFT fft_r;
FFT fft_l;

boolean analyze = false;
boolean draw = true;

float darkness = 8.0;
float scale = 3000; // Set same as image size

// Change these according to song you're painting
// Will be used to calculate rotation speed
int song_minutes = 0;
int song_seconds = 29;

// Number of frames needed for a full rotation
int total_frames = (30 * (song_minutes * 60 + song_seconds));

int count = 0;
int datasize = total_frames * 4098;
float data[] = new float[datasize];

PGraphics pg;

void setup()
{
  // Define canvas params
  //fullScreen();
  size(3000,3000);
  
  pg = createGraphics(3000, 3000);
  background(255);
  frameRate(300);
  read_from_file("C:/cygwin64/home/Oday/code/git/processing-toys/still_file/prologue.dat", data, datasize);
  
  /*
  if (analyze) {
    pg = createGraphics(60, 60);
    background(255);
  }
  */

  // Change audio file here
  minim = new Minim(this);
  player = minim.loadFile("../mp3/prologue.mp3", 4096);
  
  player.play();

  fft_r = new FFT( player.bufferSize(), player.sampleRate() );
  fft_l = new FFT( player.bufferSize(), player.sampleRate() );
}

void draw()
{
  background(255);
  
  fft_r.forward( player.right );
  fft_l.forward( player.left );
  
  if (draw) {
    pg.beginDraw();
    pg.noStroke();
  
    // Start transformation matrix
    pg.pushMatrix();
    
    // Move origin to the center of the screen
    // Then rotate the canvas, rotation speed scaled to song length
    pg.translate(scale/2.0,scale/2.0);
    pg.rotate(((float)frameCount)/total_frames*2.0*PI - PI/2.0);
    
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
      
      // data[count*4098 + i + 2049] = fft_r.getBand(i);
      // data[count*4098 + i       ] = fft_l.getBand(i);
      
      pg.fill(0,0,0,(
        data[frameCount*4098 + i + 2049]
      )*darkness);
      
      j = i+1;
      barsize = pow((j+1)/maxj,0.7)*maxj - pow(j/maxj,0.7)*maxj; 
      
      pg.ellipse(position, 0, barsize, 1);
      position = position + barsize;
    }
  
    position = 0;
  
    // Invert X axis to draw inner ring
    pg.scale(-1,1);
    
    for (int i=0; i<fft_l.specSize()/2; i++) {
      pg.fill(0,0,0,(
        data[frameCount*4098 + i       ]
      )
      *darkness);
      
      j = i+1;
      barsize = pow((j+1)/maxj,0.7)*maxj - pow(j/maxj,0.7)*maxj; 
      
      pg.ellipse(position, 0, barsize, 1);
      position = position + barsize;
    }
  
    pg.popMatrix();
    pg.endDraw();
    // Reset transformation matrix
    
    // Save frame once full rotation done
    if (frameCount == total_frames) { 
      pg.save("prologue.png");
      exit();
    }
    
     //image(pg,(width-scale)/2,(height-scale)/2);//,width,height);
    image(pg,(width-scale)/2,0);//,width,height);
    
    if (frameCount % 30 == 0) {
      println("rate=" + frameRate);
      println("rotation=" + (float)frameCount/total_frames);
    }
    // print(frameCount + " ");
  }
  
  if (analyze) {
    if (frameCount % 30 == 0) {
      println("at " + frameRate + " fps ");
    }

    print(count + " ");
    for (int i=0; i<fft_r.specSize(); i++) {
      data[count*4098 + i + 2049] = fft_r.getBand(i);
      data[count*4098 + i       ] = fft_l.getBand(i);
    }
    count++;
    if ( count == total_frames ) {  
      write_to_file("C:/cygwin64/home/Oday/code/git/processing-toys/still_file/prologue.dat", data, datasize);
      exit();
    }
  }

}

void keyPressed() {
  if (key == 'q') {
    pg.save("prologue.png");
    exit();      
  }
}

void write_to_file(String filename, float[] data, int size) {
  
  try {
  FileOutputStream fos = new FileOutputStream(filename);
  BufferedOutputStream bos = new BufferedOutputStream(fos);
  
 int intBits;
  
  for (int i=0; i < size; i++) {
    intBits = Float.floatToIntBits(data[i]);
    bos.write( 
      (new byte[] {(byte) (intBits >> 24), (byte) (intBits >> 16), (byte) (intBits >> 8), (byte) (intBits)}), 0, 4
    );
    if ( i % (floor(size/100)) == 0 ) {
      print( floor(i*100/size) + "% ");
    }
  }
    bos.flush();
    fos.flush();
    bos.close();
  
  } catch (Exception e) {
    println("Could not write to file");
    println(e.getMessage());
    exit();
  }
  
}

void read_from_file(String filename, float[] data, int size) {
  
  try {
  FileInputStream fis = new FileInputStream(filename);
  BufferedInputStream bis = new BufferedInputStream(fis);
  
  byte[] intBytes = new byte[4];
  
  for (int i=0; i < size; i++) {
    bis.read(intBytes,0,4);
    data[i] = Float.intBitsToFloat( (int)(intBytes[0] << 24 | (intBytes[1] & 0xFF) << 16 | (intBytes[2] & 0xFF) << 8 | (intBytes[3] & 0xFF)) );
  }
    bis.close();
  
  } catch (Exception e) {
    println("Could not read from file");
    println(e.getMessage());
    exit();
  }
  
}
