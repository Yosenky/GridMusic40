import grafica.*;  // For graphing

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// Grid Music - Probablistic Composition tool (beta)
// Author: Nels Oscar
// Mar 2011

// This is a mostly functional demonstration of the 
// capabilities of a simple expansion of a seed melody
// this tool provides a user with the basic components
// to compose or generate a seed melody and to play back the 
// expansion

// Modified: spc, 9/30/11 - 10/4/12
// Modified: stehnce0, 2/13/17, updated project to Processing 3
// Modified: jrkm, 6/6/22-7/16/22, updated to Processing 4

import controlP5.*;

import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;

// base note values
int C = 0;
int D = 2;
int E = 4;
int F = 5;
int G = 7;
int A = 9;
int B = 11;

// Scales/Modes
int MINOR      = 0;
int MAJOR      = 1;
int PENTATONIC = 2;
int WHOLETONE  = 3;
int CHROMATIC  = 4;
int OCTATONIC  = 5;
int MESSIAN1   = 6;          
int MESSIAN2   = 7;           
int MESSIAN3   = 8;           
int MESSIAN4   = 9;           
int MESSIAN5   = 10;          
int MESSIAN6   = 11;          
int MESSIAN7   = 12;          
int IONIAN     = 13;            
int DORIAN     = 14;            
int PHRYGIAN   = 15;          
int LYDIAN     = 16;            
int LYDIAN_MIXOLYDIAN=17; 
int MIXOLYDIAN = 18;       
int AEOLIAN    = 19;           
int LOCRIAN    = 20;           

// BASE_DUR corresponds to a sixteenth note
float BASE_DUR = 0.0625;

PApplet app = this;
Minim minim;
AudioOutput out;
SineWave squareW;
LowPassSP   lowpass;
Grid grid;
ControlP5 controlP5;
Scale currScale;
ControlWindow cWin;
PVector gridLoc;
PVector gridS;
float tempo=60.;
int w,h;
GPlot plot;
boolean plotActivated = false;
NoiseGeneration noiseG;

void setup() {
  size(1920,1080);
  w = width;
  h = height;
  // a few Grid defaults
  currScale = new Scale(A, WHOLETONE);
  gridLoc   = new PVector(width*20/40, height/40);
  // grid constructor is (position, scale, note duration, total seed duration)
  grid      = new Grid(gridLoc, currScale, BASE_DUR, 32);

  // Minim AudioOutput setup
  minim = new Minim(this);
  out   = minim.getLineOut();
 
  // setup Grid controls
  setupControls();
  surface.setResizable(true);
  
  //registerMethod("pre",this);

  plot = new GPlot(this,width*20/40, height*22/40, width*15/40, height*16/40);
  
  noiseG = new NoiseGeneration(grid);

}


//Method for auto resizing UI when window size changes
/*
void pre(){
 if(w != width || h != height){
   w = width;
   h = height;
   setupControls();
 }
}
*/

void draw() {
  background(150);
  controlP5.draw();
  if(plotActivated){
    plot.defaultDraw();
  }
}

//Returns the plot
GPlot getPlot(){
  return plot;
}

void happyBirthday() {
  // hardcoded pitches and durations for "Happy Birthday!"
  int[] pitches= {
    67, 67, 69, 67, 72, 71,
    67, 67, 69, 67, 74, 72,
    67, 67, 76, 74, 72, 71, 69,
    75, 75, 74, 72, 73, 72   
  };

  float[] durs= { 
    0.1875, 0.0625, 0.25, 0.25, 0.25, 0.5,
    0.1875, 0.0625, 0.25, 0.25, 0.25, 0.5,
    0.1875, 0.0625, 0.25, 0.25,  0.25, 0.25, 0.25,
    0.1875, 0.0625, 0.25, 0.25, 0.25, 0.5
  };

  println(sum(durs)/BASE_DUR);
  controlP5.getController("CompLength").setValue(sum(durs) / BASE_DUR);
  currScale = new Scale(A, MAJOR);
  grid.update(currScale, BASE_DUR, (int) (sum(durs) / BASE_DUR));
  grid.setGrid(pitches, durs);
}

 void readFile(String filename){
    BufferedReader reader = createReader("seq/"+filename);  
    String line;
    int lineCounter = 0;
    int i = 0;
    float[] fileDurs = new float[10]; 
    int[] filePitches = new int[10];
    int fileRoot = 0;
    int fileType = 0;
    boolean reading = true;
    while(reading){
      try {
        line = reader.readLine();
        lineCounter++;
      } catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      if (line == null) {
        reading=false;
      } 
      else {
        if(lineCounter==1){}
        else if(lineCounter==2){
          fileDurs = new float[int(line)];
          filePitches = new int[int(line)];
        }
        else if(lineCounter==3){
          fileRoot = int(line);
        }
        else if(lineCounter==4){
          fileType = int(line);
        }
        else if(lineCounter==5){}
        else {
          String[] pieces = split(line, ",");
          print(pieces[0]);println(" "+pieces[1]);
          filePitches[i]=int(pieces[0]);
          fileDurs[i]=float(pieces[1]);
          i++;
        }
      }
    }
    println(sum(fileDurs)/BASE_DUR);
    controlP5.getController("CompLength").setValue(sum(fileDurs) / BASE_DUR);
    currScale = new Scale(fileRoot, fileType);
    grid.update(currScale, BASE_DUR, (int) (sum(fileDurs) / BASE_DUR));
    grid.setGrid(filePitches, fileDurs);
  }

float sum(float[] arr) {
  float agg=0.0;
  for(int i=0; i<arr.length; i++) {
    agg+=arr[i];
  }
  return agg;
}

void stop() {
}
