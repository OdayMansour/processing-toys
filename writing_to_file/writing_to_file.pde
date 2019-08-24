import java.io.BufferedOutputStream;
import java.io.FileOutputStream;

import java.io.BufferedInputStream;
import java.io.FileInputStream;


void setup()
{
  frameRate(30);
  size(30,30);
  background(255);
}

void draw()
{
  int size = 8;
  float data[] = new float[size];
  
  data[0] = 1.8;
  data[1] = 1.2;
  data[2] = 1.990;
  data[3] = 1.2;
  data[4] = 1.0;
  data[5] = 1.991;
  data[6] = 1.337;
  data[7] = 6.9;

  write_to_file("C:/cygwin64/home/Oday/code/git/processing-toys/writing_to_file/writing.dat", data, 8);
  
  float readdata[] = new float[size];
  
  read_from_file("C:/cygwin64/home/Oday/code/git/processing-toys/writing_to_file/writing.dat", readdata, size);
  
  println(readdata[0]);
  println(readdata[1]);
  println(readdata[2]);
  println(readdata[3]);
  println(readdata[4]);
  println(readdata[5]);
  println(readdata[6]);
  println(readdata[7]);
  
  exit();
  
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
  // int intBits;
  
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
