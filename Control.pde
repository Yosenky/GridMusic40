// Grid Music - Probablistic Composition tool (beta)
// Author: Nels Oscar
// Mar 2011
// Modified: spc, 9/30/11 - 10/4/12
// Modified: jrkm, 6/6/22-7/16/22

String PLY = "Play";
String EXP = "Expand";
String VCS = "Voices";              // number of voices
String EXPLEN = "Expansion Size";   // expansion length
String CNCT = "Concat";             // concatanate or not
String REV = "Reverse";
String TMP = "Tempo";
String MAXSHFT = "MaxShift";
String SCL = "scale";
String MOD = "mode";
String RND = "Random";
String RWLK = "RandomWalk";
String RWLKINT = "RandomInterval";
String HPYBD = "Happy Birthday";
String WGHTR = "Weighted Random";
String CLR = "Clear";
String CMPLN = "CompLength";
String MEL = "Melody";
String SAVEXP = "Expansion";
String TRI = "Triangle";
String SQR = "Square";
String SIN = "Sine";
String SAW = "Saw";
String QTR = "Q-Pulse";
String BRWN = "Brownian Noise";
String LYRS = "Layers of noise";
String RESIZE = "Resize";
String NRANG = "Noise Range";
String PNK = "Pink Noise";
String STGOL = "Send to GameOfLife";



int numberOfLayers = 1;

String TESTING = "TEST";


void setupControls() {
  //initailizing the controlP5 object for use with all UI features below
  controlP5 = new ControlP5(this);
  
  //Creating fonts so that the UI text is more legible
  PFont BarFont       = createFont("unispaceregular.ttf",width/96);
  PFont UIFont        = createFont("Candal.ttf",width/107);
  PFont SmallerUIFont = createFont("Candal.ttf", width/148);
  controlP5.setFont(BarFont);

  //
  // Create control groups
  //
  ControlGroup generalControls = controlP5.addGroup("Controls", width*1/40 , height*2/40);
  generalControls.setBackgroundHeight((height*34/40)/2);
  generalControls.setWidth(width/6);
  generalControls.setBarHeight(height/40);
  
  ControlGroup scaleModeControls = controlP5.addGroup("scales/modes", width*10/40, height*2/40);
  scaleModeControls.setBackgroundHeight((height*34/40)/2);
  scaleModeControls.setWidth(width/6);
  scaleModeControls.setBarHeight(height/40);
  
  ControlGroup generationControls = controlP5.addGroup("Generate", width/40, 19*height/40);
  generationControls.setBackgroundHeight((height*16/40)/2);
  generationControls.setWidth(width/6);
  generationControls.setBarHeight(height/40);
  
  ControlGroup savingControls = controlP5.addGroup("save", width*10/40, height*33/40);
  savingControls.setBackgroundHeight((height*16/40)/2);
  savingControls.setWidth(width/6);
  savingControls.setBarHeight(height/40);
  
  ControlGroup soundSettingsControls = controlP5.addGroup("adsr", width*10/40, height*21/40);
  soundSettingsControls.setBackgroundHeight((height*16/40)/2);
  soundSettingsControls.setWidth(width/6);
  soundSettingsControls.setBarHeight(height/40);
  
  ControlGroup waveformControls = controlP5.addGroup("waveform", width/40, 26*height/40);
  waveformControls.setBackgroundHeight((height*16/40)/2);
  waveformControls.setWidth(width/6);
  waveformControls.setBarHeight(height/40);
  
  ControlGroup noiseGenerationControls = controlP5.addGroup("Noise Generation", width/40, 32*height/40);
  noiseGenerationControls.setBackgroundHeight((height*16/40)/2);
  noiseGenerationControls.setWidth(width/6);
  noiseGenerationControls.setBarHeight(height/40);
  
  
  //
  // GROUP GENERALCONTROLS
  //
  // Add controls to CNTRLS section
  
  // A bang controller triggers an event when pressed  
  // Constructor format for bang: (object, index, name, xCoord, yCoord, width, height)
  // To my knowledge, the object parameter can refer to literally any object and it will work
  controlP5.addBang(controlP5, PLY, PLY, 0         , 0, width/36, width/36).setGroup(generalControls).setFont(UIFont);
  controlP5.addBang(controlP5, CLR, CLR, width*3/72, 0, width/36, width/36).setGroup(generalControls).setFont(UIFont);
  controlP5.addBang(controlP5, EXP, EXP, width*6/72, 0, width/36, width/36).setGroup(generalControls).setFont(UIFont);
  
  // New Constructor format for toggle(object, index, name, defaultValue, xCoord, yCoord, width, height)
  // When using the new constructor, the program breaks, we will continue to use the deprecated constructors for now
  // Same deal with the object parameter, it doesn't seem to matter
  // setColorBackground sets the color of the object when not active
  // setColorActive sets the color of the object when it is active(selected)
  // setColorForeground sets the color when it is being hovered over
  color activeToggleColor = color(14,220,55);
  color inactiveToggleColor = color(0,0,0);
  color hoveredToggleColor = color(80,80,80);

  controlP5.addToggle(CNCT)
             .setBroadcast(false)
             .setValue( true)
             .setPosition(width*2/72, height*7/80)
             .setSize(width/36,width/36)
             .setGroup(generalControls)
             .setColorForeground(hoveredToggleColor)
             .setColorBackground(inactiveToggleColor)
             .setColorActive(activeToggleColor)
             .setFont(UIFont)
             .setBroadcast(true);

  controlP5.addToggle(REV)
             .setBroadcast(false)
             .setValue(false)
             .setPosition(width*6/72, height*7/80)
             .setSize(width/36,width/36)
             .setGroup(generalControls)
             .setColorForeground(hoveredToggleColor)
             .setColorBackground(inactiveToggleColor)
             .setColorActive(activeToggleColor)
             .setFont(UIFont)
             .setBroadcast(true);
  
  // Voices Slider
  controlP5.addSlider(VCS)
           .setBroadcast(false)
           .setPosition(0, height*14/80)
           .setSize(width/10, height/36)
           .setRange(1 , 4)
           .setValue(2)
           .setGroup(generalControls)
           .setFont(UIFont)
           .setNumberOfTickMarks(4)
           .showTickMarks(false)
           .setBroadcast(true);
             
   // Expansion length slider
   controlP5.addSlider(EXPLEN)
             .setBroadcast(false)
             .setPosition(0, height*17/80)
             .setSize(width/10, height/36)
             .setRange(1,240)
             .setValue(120)
             .setGroup(generalControls)
             .setFont(UIFont)
             .setNumberOfTickMarks(240)
             .showTickMarks(false)
             .setBroadcast(true);
             
  // Max shift slider
   controlP5.addSlider(MAXSHFT)
             .setBroadcast(false)
             .setPosition(0, height*20/80)
             .setSize(width/10, height/36)
             .setRange(0 , 16)
             .setValue(8)
             .setGroup(generalControls)
             .setFont(UIFont)
             .setNumberOfTickMarks(17)
             .showTickMarks(false)
             .setBroadcast(true);  
  // Composition length slider
   controlP5.addSlider(CMPLN)
             .setBroadcast(false)
             .setPosition(0, height*23/80)
             .setSize(width/10, height/36)
             .setRange(8 , 100)
             .setValue(8)
             .setGroup(generalControls)
             .setFont(UIFont)
             .setNumberOfTickMarks(93)
             .showTickMarks(false)
             .setBroadcast(true);  
  // Tempo slider
   controlP5.addSlider(TMP)
             .setBroadcast(false)
             .setPosition(0, height*26/80)
             .setSize(width/10, height/36)
             .setRange(50, 150)
             .setValue(tempo)
             .setGroup(generalControls)
             .setFont(UIFont)
             .setNumberOfTickMarks(101)
             .showTickMarks(false)
             .setBroadcast(true);
  
  
  //
  // GROUP SCALEMODECONTROLS
  //
  // Add radio buttons to SCALE/MODE section
  // addRadio constructor format (name, xCoord, yCoord)
  RadioButton r = controlP5.addRadio(SCL, 0, 0);
  // addItem constructor format (name, value)
  r.addItem("A", 0 ).setSize(width/60,width/60);
  r.addItem("Bb", 1).setSize(width/60,width/60).toUpperCase(false); //toUpperCase(false) allows the second 'b' to be lower case for the flat symbol
  r.addItem("B", 2 ).setSize(width/60,width/60);
  r.addItem("C", 3 ).setSize(width/60,width/60);
  r.addItem("C#", 4).setSize(width/60,width/60);
  r.addItem("D", 5 ).setSize(width/60,width/60);
  r.addItem("Eb", 6).setSize(width/60,width/60).toUpperCase(false);
  r.addItem("E", 7 ).setSize(width/60,width/60);
  r.addItem("Fb", 8).setSize(width/60,width/60).toUpperCase(false);
  r.addItem("F", 9 ).setSize(width/60,width/60);
  r.addItem("Gb",10).setSize(width/60,width/60).toUpperCase(false);
  r.addItem("G", 11).setSize(width/60,width/60);
  r.addItem("G#",12).setSize(width/60,width/60);
  r.activate(0);
  r.setGroup(scaleModeControls);
  
  // setSpacingColumn adjusts spacing between columns
  // setItemsPerRow sets the number of items per row
  color radioInactiveColor = color(0,45,90);
  color radioActiveColor = color(98,217,237);
  RadioButton r2 = controlP5.addRadio(MOD, width*3/60, 0)
                            .setItemsPerRow(2)
                            .setSpacingColumn(width*3/60)
                            .setColorBackground(radioInactiveColor)
                            .setColorActive(radioActiveColor);
  r2.addItem("Mjr",      0).setSize(width/60,width/60);
  r2.addItem("Mnr",      1).setSize(width/60,width/60);
  r2.addItem("Pnt",      2).setSize(width/60,width/60);
  r2.addItem("Whl",      3).setSize(width/60,width/60);
  r2.addItem("Chr",      4).setSize(width/60,width/60);
  r2.addItem("Oct",      5).setSize(width/60,width/60);
  r2.addItem("MS1",      6).setSize(width/60,width/60);
  r2.addItem("MS2",      7).setSize(width/60,width/60);
  r2.addItem("MS3",      8).setSize(width/60,width/60);
  r2.addItem("MS4",      9).setSize(width/60,width/60);
  r2.addItem("MS5",     10).setSize(width/60,width/60);
  r2.addItem("MS6",     11).setSize(width/60,width/60);
  r2.addItem("MS7",     12).setSize(width/60,width/60);
  r2.addItem("ION",     13).setSize(width/60,width/60);
  r2.addItem("DOR",     14).setSize(width/60,width/60);
  r2.addItem("PHR",     15).setSize(width/60,width/60);
  r2.addItem("LYD",     16).setSize(width/60,width/60);
  r2.addItem("LD-MXLD", 17).setSize(width/60,width/60);
  r2.addItem("MXLD",    18).setSize(width/60,width/60);
  r2.addItem("AEO",     19).setSize(width/60,width/60);
  r2.addItem("LOC",     20).setSize(width/60,width/60);
  r2.activate(0);
  r2.setGroup(scaleModeControls);
  
  
  //
  // GROUP L3
  //
  // Add generators to GEN section
  // Constructor Format(Object, index, name, xCoord, yCoord, width, height)
  
  // Random generation
  controlP5.addBang(RND)
           .setBroadcast(false)
           .setPosition(0             , height/80)
           .setSize(width/48, width/48)
           .setGroup(generationControls)
           .setFont(SmallerUIFont)
           .setBroadcast(true);   
  // Random walking generation
  controlP5.addBang(RWLK)
           .setBroadcast(false)
           .setPosition(width*3/72, height/80)
           .setSize(width/48, width/48)
           .setGroup(generationControls)
           .setFont(SmallerUIFont)
           .setBroadcast(true);  
  // Random walking interval generation
  controlP5.addBang(RWLKINT)
           .setBroadcast(false)
           .setPosition(width*7/72, height/80)
           .setSize(width/48, width/48)
           .setGroup(generationControls)
           .setFont(SmallerUIFont)
           .setBroadcast(true);   
  // Weighted random generation
  controlP5.addBang(WGHTR)
           .setBroadcast(false)
           .setPosition(0, height*6/80)
           .setSize(width/48, width/48)
           .setGroup(generationControls)
           .setFont(SmallerUIFont)
           .setBroadcast(true); 
  //controlP5.addBang(controlP5, HPYBD  , HPYBD  , 0             , height*8/80, width/36, width/36).setGroup(l3).setFont(UIFont);  // Happy Birthday Button
  
  
  //
  // GROUP L4
  // 
  // Add buttons to SAVE section
  // addButton constructor syntax (object, index, name, value, xCoord, yCoord, width, height)
  //controlP5.addButton(controlP5, MEL   , MEL   , 1.0, 0         , width/96   , width*3/36, height*2/36).setGroup(savingControls);
  //controlP5.addButton(controlP5, SAVEXP, SAVEXP, 2.0, width*7/72, width/96   , width*3/36, height*2/36).setGroup(savingControls);
  //controlP5.addButton(controlP5, "LOAD", "LOAD", 1.0, 0         , height*3/36, width*3/36, height*2/36).setGroup(savingControls);
  //controlP5.addTextfield("FILE").setPosition(width*7/72,height*3/36).setText("song.seq").setSize(width*3/36,height/36).setGroup(savingControls);
  
  // Send to game of life
  controlP5.addBang(STGOL)
           .setBroadcast(false)
           .setPosition(0, width/96)
           .setSize(width*3/36, height*2/36)
           .setGroup(savingControls)
           .setFont(UIFont)
           .setBroadcast(true);   
  //
  // GROUP L5
  //
  // Add controls to ADSR section - stehnce0
  
  controlP5.addKnob("atk")
               .setRange(0.01,1)
               .setRadius(height/36)
               .setPosition(0, 0)
               .setValue(0.01)
               .setDragDirection(Knob.VERTICAL)
               .setGroup(soundSettingsControls);
  controlP5.addKnob("dly") //
               .setRange(0.01,1)
               .setRadius(height/36)
               .setPosition(width*3/48,0)
               .setValue(0.05)
               .setDragDirection(Knob.VERTICAL)
               .setGroup(soundSettingsControls);
  controlP5.addKnob("sus")
               .setRange(0,1)
               .setRadius(height/36)
               .setPosition(0,height/12)
               .setValue(0.5)
               .setDragDirection(Knob.VERTICAL)
               .setGroup(soundSettingsControls);
  controlP5.addKnob("rel")
               .setRange(0.01,3)
               .setRadius(height/36)
               .setPosition(width*3/48,height/12)
               .setValue(0.5)
               .setDragDirection(Knob.VERTICAL)
               .setGroup(soundSettingsControls);
  
  //
  // GROUP L6
  //
  // Add controls to WAVEFORM section - jrkm
  
  RadioButton r3 = controlP5.addRadio("wave", 0, height/80)
                            .setItemsPerRow(3)
                            .setSpacingColumn(width*3/60)
                            .setSpacingRow(height*1/60)
                            .setColorBackground(radioInactiveColor)
                            .setColorActive(radioActiveColor)
                            .setSize(width/10, width/10);
  r3.addItem(SIN,      0).setSize(width/10,width/10);
  r3.addItem(SQR,      1).setSize(width/60,width/60);
  r3.addItem(TRI,      2).setSize(width/60,width/60);
  r3.addItem(SAW,      3).setSize(width/60,width/60);
  r3.addItem(QTR,      4).setSize(width/60,width/60);
  r3.activate(0);
  r3.setGroup(waveformControls);  
  
  
  //
  // GROUP L7
  //
  // Add controls to Noise Generation section - jrkm
  // Number of noise layers slider
  controlP5.addSlider(LYRS)
            .setBroadcast(false)
            .setPosition(0, 0)
            .setSize(width/10, height/36)
            .setRange(1, 20)
            .setValue(1)
            .setGroup(noiseGenerationControls)
            .setFont(UIFont)
            .setNumberOfTickMarks(20)
            .showTickMarks(false)
            .setBroadcast(true);    
  // Brownian noise generation           
  controlP5.addBang(BRWN)
           .setBroadcast(false)
           .setPosition(0, height*4/80)
           .setSize(width/48, width/48)
           .setGroup(noiseGenerationControls)
           .setFont(SmallerUIFont)
           .setBroadcast(true);
  // Pink noise generation        
  controlP5.addBang(PNK)
           .setBroadcast(false)
           .setPosition(width*3/48, height*4/80)
           .setSize(width/48, width/48)
           .setGroup(noiseGenerationControls)
           .setFont(SmallerUIFont)
           .setBroadcast(true);              
  // Noise range slider    
  controlP5.addSlider(NRANG)
            .setBroadcast(false)
            .setPosition(0, height*10/80)
            .setSize(width/10, height/36)
            .setRange(1, 5)
            .setValue(1)
            .setGroup(noiseGenerationControls)
            .setFont(UIFont)
            .setNumberOfTickMarks(5)
            .showTickMarks(false)
            .setBroadcast(true);   
}

// Event getController for Radio Button scale
public void scale(int theValue) {
  RadioButton b  = (RadioButton) controlP5.getGroup(MOD);
  currScale      = new Scale(theValue+9, (int) b.getValue()); // magic number 9 here !!!
  Slider complen = (Slider) controlP5.getController(CMPLN);
  grid.update(currScale, BASE_DUR, (int) complen.getValue());
}

// Event getController for Radio Button mode
public void mode(int theValue) {
  RadioButton b  = (RadioButton) controlP5.getGroup(SCL);
  currScale      = new Scale((int) b.getValue(), theValue);
  Slider complen = (Slider) controlP5.getController(CMPLN);
  grid.update(currScale, BASE_DUR, (int) complen.getValue());
}

// Event getController for Radio Button wave
// Changes the waveform based on the value of the radio button
public void wave(int theValue) {
  if(theValue == 0){
    grid.wf = Waves.SINE;
  } else if (theValue == 1) {
      grid.wf = Waves.SQUARE;
  } else if (theValue == 2) {
      grid.wf = Waves.SAW;
  } else if (theValue == 3) {
      grid.wf = Waves.TRIANGLE;
  } else if (theValue == 4) {
      grid.wf = Waves.QUARTERPULSE;  
  }
}


// Event handler for all other getControllers
void controlEvent(ControlEvent theEvent) {
  PlotController plotController = new PlotController();
  NoiseGeneration noiseG = new NoiseGeneration(grid);
  if (theEvent.isController()) {
    Slider complen=(Slider)controlP5.getController(CMPLN);
    if(controlP5.getController(TMP) != null){ //Removes error messages on startup caused by TMP slider not yet being initialized
      out.setTempo(controlP5.getController(TMP).getValue());
    }
    if (theEvent.getController().getName() == PLY) {
      plotController.clearPlot();
      grid.play();
    } else if (theEvent.getController().getName() == EXP) {
      Slider vcs = (Slider)controlP5.getController(VCS);    // number of voices
      Slider len = (Slider)controlP5.getController(EXPLEN); // expansion length
      Toggle cnct = (Toggle)controlP5.getController(CNCT);  // concatanate or not
      for (int i=0; i<vcs.getValue (); i++) {
        grid.playExp((int)len.getValue(), cnct.getState());
      }

      println("--Playing Expansion--");
      println("max sequence shift:         "+grid.seq.maxPShift);
      println("sequence shift probability: "+grid.seq.tshiftThreshold);
      println("pitch shift probablity:     "+grid.seq.pshiftThreshold);
      println("rest probablity:            "+grid.seq.restThreshold);
    } else if (theEvent.getController().getName()==MAXSHFT) {
      Slider s=(Slider)controlP5.getController(MAXSHFT);
      grid.seq.maxPShift=(int)s.getValue();
    } else if (theEvent.getController().getName()==LYRS) { // Layers slider
      Slider s=(Slider)controlP5.getController(LYRS);
      numberOfLayers=(int)s.getValue();
    }else if (theEvent.getController().getName()==RND) { // Random melody
      grid.clear();
      grid.randomMelody();
    } else if (theEvent.getController().getName()==RESIZE) { //Random walking melody
      grid.clear();
      grid.resizeGrid(numberOfLayers, numberOfLayers);
    } else if (theEvent.getController().getName()==RWLK) { //Random walking melody
      grid.clear();
      grid.randomWalkMelody();
    } else if (theEvent.getController().getName()==RWLKINT) { //Random interval walking melody
      grid.clear();
      grid.randomIntervalWalkMelody();
    } else if (theEvent.getController().getName().equals(BRWN)) { // Brownian Noise
      plotController.clearPlot();
      grid.clear();
      mode(2); // Sets mode to pentatonic
      RadioButton b  = (RadioButton) controlP5.getGroup(MOD); // Grabs radio button
      b.activate(2); // Adjusts the visuals on the radio button
      Slider s = (Slider) controlP5.getController(NRANG);
      float noiseRange = s.getValue();
      int i = 0;
      while(i < numberOfLayers){
       noiseG.generateBrownianNoise(noiseRange);
        i++;
      }
    }else if (theEvent.getController().getName().equals(PNK)) { // Pink Noise
      plotController.clearPlot();
      grid.clear();
      int i = 0;
      while(i < numberOfLayers){
       noiseG.generatePinkNoise(70);
        i++;
      }
    }else if (theEvent.getController().getName().equals(HPYBD)) { //Happy Birthday
      happyBirthday();
    } else if (theEvent.getController().getName() == CLR) { //Clear
      plotController.clearPlot();
      grid.clear();
    } else if (theEvent.getController().getName() == CMPLN) {
      grid.clear();
      grid.update(currScale, BASE_DUR, (int) complen.getValue());
    } else if (theEvent.getController().getName() == MEL) {
      print("Saving...");
      grid.buildSequence();
      grid.checkModifiers();
      grid.seq.writeSequence();
      println("done");
    } else if (theEvent.getController().getName() == SAVEXP) {
      print("Saving...");
      grid.buildSequence();
      grid.buildSequence();
      grid.checkModifiers();
      Toggle cnct = (Toggle) controlP5.getController(CNCT);
      Slider len = (Slider) controlP5.getController(EXPLEN);
      if (cnct.getState()) {
        // states the original seed before going on to the expansion
        grid.seq = grid.seq.concat(grid.seq.getExpandedSequence((int)len.getValue()));
      } else {
        grid.seq = grid.seq.getExpandedSequence((int)len.getValue());
      }
      grid.seq.writeSequence();
      println("done");
    } else if (theEvent.getController().getName() == "atk") {
      grid.adsr[0]=theEvent.getController().getValue();
    } else if (theEvent.getController().getName() == "dly") {
      grid.adsr[1]=theEvent.getController().getValue();
    } else if (theEvent.getController().getName() == "sus") {
      grid.adsr[2]=theEvent.getController().getValue();
    } else if (theEvent.getController().getName() == "rel") {
      grid.adsr[3]=theEvent.getController().getValue();
    } else if (theEvent.getController().getName() == "LOAD") {
      grid.clear();
      Textfield tf = (Textfield) controlP5.getController("FILE");
      readFile(tf.getText());
    } else if (theEvent.getController().getName() == WGHTR) {
      grid.clear();
      grid.randomWeightedInterval();
    } else if (theEvent.getController().getName() == STGOL) {
      println("SENDING!");
      grid.sendInfo();
    }
  }
}
