import java.io.BufferedInputStream;
import java.io.FileInputStream;

float darkness = 8.0;
float scale = 1500; // Set same as image size

int song_minutes = 0;
int song_seconds = 29;

// Number of frames needed for a full rotation
int total_frames = (30 * (song_minutes * 60 + song_seconds));

int count = 0;
int timesize = 4096;
int specsize = 4096/2 + 1;
int datasize = total_frames * (4096+2);
float data[] = new float[datasize];

PGraphics pg;

void setup()
{
  size(300,300);
  
  pg = createGraphics(1500, 1500);
  background(255);
  frameRate(300);
  read_from_file("/Users/oday/code/git/processing-toys/mp3/prologue.dat", data, datasize);
  println("total frames = " + total_frames);
  pg.beginDraw();
  pg.background(255); //<>//
}

void draw()
{
  //background(255);
  
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
  float maxj = specsize/2;

  for (int i=0; i < specsize/2; i++) {
    // Set fill color to black, opacity proportional to amplitude at frequency band
    // Then draw a (scaled) ellipse at band position
    // ellipse size depends on the band position
    // bands near the center (bass) are very crowded
    // I went with an i^0.7 scaling function to emphasize low freqs but keep high freqs smaller and sharper
    
    // data[count*4098 + i + 2049] = fft_r.getBand(i);
    // data[count*4098 + i       ] = fft_l.getBand(i);
    
    pg.fill(0,0,0,(
      data[(frameCount-1)*4098 + i + 2049]
    )*darkness);
    
    j = i+1;
    barsize = pow((j+1)/maxj,0.7)*maxj - pow(j/maxj,0.7)*maxj; 
    
    pg.ellipse(position, 0, barsize, 1);
    position = position + barsize;
  }

  position = 0;

  // Invert X axis to draw inner ring
  pg.scale(-1,1);
  
  for (int i=0; i < specsize/2; i++) {
    pg.fill(0,0,0,(
      data[(frameCount-1)*4098 + i       ]
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
  // print(frameCount + " ");
  
  // Save frame once full rotation done
  if (frameCount == total_frames) { 
    pg.save("prologue.png");
    exit();
  }
  
  //image(pg,(width-scale)/2,(height-scale)/2);//,width,height);
  //image(pg,(width-scale)/2,0);//,width,height);
  
  if (frameCount % 30 == 0) {
    println("rate=" + frameRate);
    println("rotation=" + (float)frameCount/total_frames);
    image(pg,0,0,width,height);
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
