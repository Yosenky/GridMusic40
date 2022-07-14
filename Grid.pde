// Grid Music - Probablistic Composition tool (beta)
// Author: Nels Oscar
// Mar 2011
// Modified: spc, 9/30/11 - 10/4/13
// Modified: jrkm, 6/6/22-7/16/22

public class Grid {
  int totalDur=32;
  Block[][] grid;
  PVector pos;
  float adsr[] = new float[4];
  // 0 : attack, 2 : sustain
  // 1 : delay,  3 : release
  Waveform wf = Waves.SINE;
  Scale form;
  Sequence seq;
  float baseDuration;
  int blockWidth;
  int blockHeight;
  // initialize with position, scale, duration represented by grid position, and total seed duration 
  public Grid(PVector pos, Scale sc, float baseDur, int tDur) {
    this.pos=pos;
    baseDuration=baseDur;
    form=sc;
    seq=new Sequence(3, 0, 0);
    seq.setADSR(adsr);
    seq.setWaveform(wf);
    
    // a Grid is an array of Blocks - note how totalDur is modified here
    grid=new Block[totalDur=tDur][form.notes.length];
    blockWidth  = (width*18/40)/grid.length;
    blockHeight = (height*20/36)/grid[0].length;
    initGrid();

    // interaction with the PApplet (!!! works in 1.5.1 but changed in 2.0 !!!)
    app.registerMethod("draw", this);
    app.registerMethod("mouseEvent", this);
    
    adsr[0]=0.01; // base adsr values - charles
    adsr[1]=0.05;
    adsr[2]=0.5;
    adsr[3]=0.5;
  }

  // update state of the Grid (new scale, base duration, and total seed duration
  public void update(Scale sc, float  baseDur, int tDur) {
    form=sc;
    baseDuration=baseDur;
    totalDur=tDur;
    grid=new Block[totalDur][form.notes.length];
    blockWidth  = (width*18/40)/grid.length;
    blockHeight = (height*20/36)/grid[0].length;
    initGrid();
  }
  

  // initGrid - create a Block {currPos, (blockWidth, blockHeight), notes, baseDuration} for each Grid pos
  private void initGrid() {
    PVector SIZE = new PVector(blockWidth, blockHeight);
    for (int col=0; col < grid.length; col++) {
      for (int row=0; row < grid[col].length; row++) {
        PVector currPos = new PVector(pos.x+col*SIZE.x, pos.y+row*SIZE.y);
        grid[col][row] = new Block(currPos, 
        new PVector(SIZE.x-2, SIZE.y-2), 
        form.notes[form.notes.length - row - 1], 
        baseDuration);
      }
    }
  }
  
  
  void resizeGrid(int newBlockWidth, int newBlockHeight){
    /*
    for(int i = 0; i < grid.length; i++){
      for(int j = 0; j < grid[0].length; j++){
        grid[i][j].resize(newBlockWidth, newBlockHeight);
      }
    }
    */
    blockWidth = newBlockWidth;
    blockHeight = newBlockHeight;
    initGrid();
    
  }

  void draw() {
    stroke(50);
    for (int i=0; i < grid.length; i++) {
      for (int j=0; j < form.notes.length; j++) {
        grid[i][j].show();
      }
    }
  }

  // called on the grid when a mouse event occurs
  // !!! works in 1.5.1 but changed in 2.0 !!!
  void mouseEvent(MouseEvent event) {
    // get the x and y pos of the event
    int x = event.getX();
    int y = event.getY();

    switch (event.getAction()) {
    case MouseEvent.PRESS:
      // check for grid hits
      checkGrid(x, y);
      break;
    case MouseEvent.RELEASE:
      // do something...
      break;
    case MouseEvent.CLICK:
      // do something...
      break;
    case MouseEvent.DRAG:
      // do something...
      checkGrid(x, y);
      break;
    case MouseEvent.MOVE:
      // do something...
      break;
    }
  }

  // 
  void checkGrid(int x, int y) {
    PVector p=new PVector(x, y);
    for (int i=0; i<grid.length; i++) {
      for (int j=0; j<grid[i].length; j++) {
        grid[i][j].contains(p);
        if (grid[i][j].isSet()) {
          emptyCol(i);
          grid[i][j].isset=true;
        }
      }
    }
  }

  void emptyCol(int col) {
    for (int i=0; i<form.notes.length; i++) {
      grid[col][i].isset=false;
    }
  }

  int getLitPitch(int col) {
    int lit=-1;
    for (int i=0; i<grid[col].length; i++) {
      if (grid[col][i].isSet()) {
        lit=grid[col][i].pitch;
      }
    }
    return lit;
  }

  void buildSequence() {
    // base Probabilistic algorithm
    seq=new Sequence(grid.length, form.root, form.type);
    seq.setADSR(adsr);
    seq.setWaveform(wf);
    // uncomment for Chaos Melody Theory algorithm
    //seq=new CMT_Sequence(grid.length ,form.root ,form.type, 0.5);

    Sequence seq2=seq;
    // find note in each column
    for (int i=0; i<grid.length; i++) { 
      seq.melody[i]=getLitPitch(i);

      int durCnt=i+1;
      while (durCnt<grid.length && getLitPitch (durCnt-1)==getLitPitch(durCnt)) {
        durCnt++;
      }
      // once the durCnt has been determined the duration of the note can be set.
      seq.duration[i]=baseDuration*(float)(durCnt-i);

      // this is the case where there is no note, so it will be stored as a rest.
      if (seq.melody[i]==-1) {
        seq.melody[i]=0;
        seq.duration[i]=baseDuration;
      }
      // i must be updated since the next durCnt cols have already been examined.
      if (durCnt>i+1)
        i=durCnt-1;
    }
    // set the other parameters, there is a better way, but this works for now.
    seq.tshiftThreshold=seq2.tshiftThreshold;
    seq.pshiftThreshold=seq2.pshiftThreshold;
    seq.restThreshold=seq2.restThreshold;
    seq.maxPShift=seq2.maxPShift;
  }

  void checkModifiers() {
    if (controlP5.getController("Concat").getValue()==1) {
      if (controlP5.getController("Reverse").getValue()==1) {
        seq=seq.concat(seq.reverseNotes());
      }
    } else {
      if (controlP5.getController("Reverse").getValue()==1) {
        seq=seq.reverseNotes();
      }
    }
  }
  

  void play() {
    //plotController.clearPlot();
    
    // check the grid
    buildSequence();

    checkModifiers();
    // play back the result
    
    seq.playSequence(out, 1.0);
    
    
  }

  // Overloading play to allow for noiseRange and microtones
  void play(float noiseRange) {
   // plotController.clearPlot();
    
    // check the grid
    buildSequence();

    checkModifiers();
    // play back the result
    seq.playMicrotoneSequence(out,1.0,3);

  }
  
  
  void playExp(int len, boolean appendExp) {
    buildSequence();
    checkModifiers();
    if (appendExp) {
      // I'm playing with this.
      // I liked the idea of stating the original seed before
      // going on to the expansion
      seq=seq.concat(seq.getExpandedSequence(len));
    } else {
      seq=seq.getExpandedSequence(len);
    }
    // play as expected
    seq.setADSR(adsr);
    seq.setWaveform(wf);
    seq.playSequence(out, 0.5);
  }

  void clear() {
    for (int i=0; i<grid.length; i++) {
      emptyCol(i);
    }
  }

  int getIdxFromPitch(int pitch) {
    int idx=0;
    while (idx<form.notes.length && grid[0][idx].pitch!=pitch) {
      idx++;
    }
    return idx;
  }

  void setGrid(int[] pitches, float[] durs) {
    int pIdx=0;
    int gIdx=0;
    for (int i=0; i<durs.length&&i<grid.length; i++) {
      // calculate number of blocks to rep the dur.
      int durCnt=1;
      while (durCnt*baseDuration<durs[i]) {
        durCnt++;
      }      
      // set the correct pitch for the total duration of the note 
      for (int j=0; j<durCnt&&gIdx+j<grid.length; j++) {
        emptyCol(gIdx+j);
        println(getIdxFromPitch(pitches[pIdx]));
        grid[gIdx+j][getIdxFromPitch(pitches[pIdx])].isset=true;
      }

      if (durCnt>1)
        gIdx+=durCnt;
      else 
        gIdx++;
        pIdx++;
    }
  }

  // randomMelody - notes selected using the standard random number generator.
  void randomMelody() {
    for (int i=0; i<grid.length; i++) {
      grid[i][(int)random(0, form.notes.length)].isset=true;
    }
  }

  // randomWalkMelody - notes selected using "brownian motion" (1/f^2 randomness)
  // i.e. uses the randomness that is inherintly in Processing
  void randomWalkMelody() {
    // select starting pitch
    int pos=(int)random(form.notes.length);

    for (int i=0; i<grid.length; i++) {
      grid[i][abs(pos%grid[i].length)].isset=true;

      // select the new position
      pos+=(int)random(-3,3);
    }
  }

  // randomIntervalWalkMelody - modifies (1/f^2) randomness use the INTERVAL list to 
  //                                               determine the walk amount.
  // i.e. uses the randomness that is inherintly in Processing
  void randomIntervalWalkMelody() {
    // select starting pitch
    int pos = (int) random(form.notes.length);

    for (int i=0; i < grid.length; i++) {
      grid[i][abs(pos % grid[i].length)].isset=true;

      // select the new position
      pos += seq.INTERVALS[ (int) random(0, seq.INTERVALS.length)];
    }
  }
  
  void randomWeightedInterval(){
    int pos = (int) random(form.notes.length);
    for (int i=0; i < grid.length; i++) {
        grid[i][abs(pos % grid[i].length)].isset=true;
        // select the new position
        if(int(random(0,2))==1){
          pos += seq.INTERVALS[ (int) random(0, seq.INTERVALS.length)];
        } else {
          pos += int(random(-3,3));
        } 
    }
  }
  
  // Returns grid object
  Block[][] getGrid(){
    return grid;
  }
  
  // Gets the Y coordinates of all lit notes
  int[] getLitNotes() {
    int[] litNotesYCoordinates = new int[grid.length];
    for (int i=0; i<grid.length; i++) {
      for(int j = 0; j < grid[0].length; j++){
        litNotesYCoordinates[i] = 0; // Initialize to 0 in case no notes are lit
        if(grid[i][j].isset){
          litNotesYCoordinates[i] = j;
          j = grid[0].length;
        }
      }
    }
    return litNotesYCoordinates;
  }
  
  
  // Sends info to the GameOfLifeCompositions program
  void sendInfo(){
    OscMessage myMessage = new OscMessage("Composition Info");
    myMessage.add(grid.length); // Grid length
    myMessage.add(grid[0].length); // Grid height
    int[] litNotesYCoordinates = getLitNotes();
    for(int i = 0; i < adsr.length; i++){
      myMessage.add(adsr[i]); // ADSR values
    }
    for(int i = 0; i < litNotesYCoordinates.length; i++){
      myMessage.add(litNotesYCoordinates[i]); // Y coordinates for the notes
    }

    oscP5.send(myMessage, gameOfLifeCompositionsAddress); // Sends message
  }
}
