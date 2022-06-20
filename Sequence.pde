// Grid Music - Probablistic Composition tool (beta)
// Author: Nels Oscar
// Mar 2011
// Modified: spc, 9/30/11 - 10/4/12
// Modified: stehnce0 2/13/17
// Modified: jrkm 06/06/22 - 07/16/22
class Sequence {
  // Just an arbitrary default sequence length
  // any function that modifies this value is responsible for
  // updating changes to this value
  int length=4;
  
  // Amplitude of notes to prevent audio clipping. - stehnce0
  float amplitude = 0.4;
  float adsr[] = new float[4];
  // 0 : attack, 2 : sustain
  // 1 : delay,  3 : release
  Waveform wf = Waves.SINE;
  
  int pos=0;

  // this index into the sequence
  // is used by the playNextNote function
  // I forsee great things for this function as far as repetitive mutations to the sequence
  int currPos=0;

  // The melody/duration pairs are always the same length.
  int[] melody;
  float[] duration;

  // These are the allowable durations for a note at present.
  // Cooresponding to 1/16,1/8,1/4,1/2,1 
  float[] DUR_VALUES= {
    0.0625, 0.125, 0.25, 0.5, 1
  };
  int[] INTERVALS= {
    -7, -6, -4, -2, 2, 4, 6, 7
  };

  // The following are parameters that can be set for the probabalistic expansion
  float tshiftThreshold = 0.2;
  float pshiftThreshold = 0.5;
  float restThreshold = 0.1;
  int maxPShift = 8;
  // Maybe someday some harmony
  Scale scale;
  
  GPlot plot;

  // Its possible I have too many constructors, but I haven't the heart to kill them off yet

  public Sequence(int[] pitches, float[] durs, int root, int type) {
    length=pitches.length;
    melody=pitches;
    duration=durs;
    scale=new Scale(root, type);
  }

  public Sequence(int[] pitches) {
    duration=new float[pitches.length];
    for (int i=0; i<duration.length; i++) {
      duration[i]=0.2;
    }
    melody=pitches;
    length=pitches.length;
    scale=new Scale(A, MAJOR);
  }

  public Sequence(int numNotes, int root, int type) {
    length=numNotes;
    melody=new int[length];
    duration=new float[length];
    scale=new Scale(root, type);
    //genSequence();
  }

  public Sequence(Sequence[] sequences) {
    // sum for length
    length=0;
    scale=new Scale(A, MAJOR);
    for (int i=0; i<sequences.length; i++) {
      length+=sequences[i].length;
    }
    melody=new int[length];
    duration=new float[length];
    int k=0;
    for (int i=0; i<sequences.length; i++) {
      for (int j=0; j<sequences[i].length; j++) {
        melody[k]=sequences[i].melody[j];
        duration[k]=sequences[i].duration[j];
        k++;
      }
    }
  }

  /* Sequence Methods */

  void genSequence() {
    for (int i=0; i<melody.length; i++) {
      melody[i]=scale.getRandomNote();
      duration[i]=DUR_VALUES[(int)random(DUR_VALUES.length)];
    }
  }

  // playSequence - send notes in Sequence to the soundcard represented by out
  /* !!! Improvement - pass the ToneInstrument as an argument !!! */
  void playSequence(AudioOutput out, float tempo) {
    // Pause note playback to build the sequence up in minim
    out.pauseNotes();

    // Its important to keep track of the time
    // the note starts
    float time=0;
    for (int i=0; i<melody.length; i++) {
      float tempDur = duration[i];
      if (i>0) {
        tempDur = 1.25 * duration[i-1];
        time += tempDur;
      }
      out.playNote(time, 1.25*duration[i], new ToneInstrument((float) PitchRep.mtof(melody[i]), amplitude, out, adsr, wf));
      time += 1.25 * duration[i];
    }

    // resume playback
    out.resumeNotes();
  }
   
  // Overriding playSequence with additional parameter noiseRange to allow for microtone generation
  void playMicrotoneSequence(AudioOutput out, float tempo, int noiseRange) {
    // Pause note playback to build the sequence up in minim
    out.pauseNotes();

    // Its important to keep track of the time
    // the note starts
    float time=0;
    for (int i=0; i<melody.length; i++) {
      
      
      int middleCMIDI = 60; // Middle C midi value, not actually using because it is too quiet
      double topFrequency =PitchRep.mtof(70 + noiseRange);
      double bottomFrequency = PitchRep.mtof(70 - noiseRange);
      
      float tempDur = duration[i];
      if (i>0) {
        tempDur = 1.25 * duration[i-1];
        time += tempDur;
      }
      float randomFrequency = random((float)bottomFrequency, (float)topFrequency);
      out.playNote(time, 1.25*duration[i], new ToneInstrument(randomFrequency, amplitude, out, adsr, wf));
      
      // Drawing the plot of the frequencies
      plot = getPlot();
      plot.getXAxis().getAxisLabel().setText("Note");
      plot.getYAxis().getAxisLabel().setText("Frequency Value");
      plot.addPoint(i, randomFrequency);
      plotActivated = true;
      
      
      time += 1.25 * duration[i];
    }

    // resume playback
    out.resumeNotes();
  }
  
  
  /* 
  //Overriding method to allow for grid, to test grid light up
   void playSequence(AudioOutput out, float tempo, Block[][] g) {
    // Pause note playback to build the sequence up in minim
    out.pauseNotes();

    // Its important to keep track of the time
    // the note starts
    float time=0;
    for (int i=0; i<melody.length; i++) {
      float tempDur = duration[i];
      if (i>0) {
        tempDur = 1.25 * duration[i-1];
        time += tempDur;
      }
      out.playNote(time, 1.25*duration[i], new ToneInstrument((float) PitchRep.mtof(melody[i]), amplitude, out, adsr, wf));
      time += 1.25 * duration[i];
    }

    // resume playback
    out.resumeNotes();
   
  } 
  */

  // playNextNote - outputs one note in sequence at a time via AudioOutput
  //    (maybe a little silly but useful in future systems that supply an external trigger)
  /* !!! Improvement - pass the ToneInstrument as an argument !!! */
  void playNextNote(AudioOutput out) {
    Note n = getNextNote();
    out.playNote(0, n.duration, new ToneInstrument((float) PitchRep.mtof(n.pitch), amplitude, out, adsr, wf));
  }

  // some new fields
  float numNotesGot;
  float numNotestoGet;

  Sequence getExpandedSequence(int nNotes) {
    int[] newPitches=new int[nNotes];
    float[] newDurs=new float[nNotes];
    numNotesGot=0;
    numNotestoGet=nNotes;
    for (int i=0; i<newPitches.length; i++) {
      Note n=getNextNote();
      newPitches[i]=n.pitch;
      newDurs[i]=n.duration;
    }
    return new Sequence(newPitches, newDurs, scale.root, scale.type);
  }

  // getNextNote - computes next note in Sequence
  Note getNextNote() {
    numNotesGot+=1;
    int transpose=0;
    if (random(1)<pshiftThreshold) {
      currPos-=random(maxPShift);
    }
    if (random(1)<tshiftThreshold) {
      transpose=INTERVALS[(int)random(INTERVALS.length)];
    } else {
      transpose=0;
    }
    if (random(1)<0.1) {
      //duration[abs(currPos%length)]=DUR_VALUES[random(DUR_VALUES.length)];
    }
    Note n;
    if (random(1)>restThreshold) {
      transpose+=find(melody[abs(currPos%length)]);
      //Note n=new Note(melody[abs(currPos%length)]+transpose,duration[abs(currPos%length)]);
      n=new Note(abs(scale.notes[abs(transpose%scale.notes.length)]), duration[abs(currPos%length)]);
      currPos++;
    } else {
      // rest
      n=new Note(0, duration[abs(currPos%length)]);
    }
    return n;
  }

  int find(int midi) {
    // go through the state scale and
    // find the index midi occurs at
    int i=0;
    int index=-1;
    while (i<=scale.notes.length) {
      if (i!=scale.notes.length)
        if (scale.notes[i]==midi) {

          index=i;
        }
      i++;
    }
    return index;
  }

  Sequence harmonize() {
    Sequence s=new Sequence(length, scale.root, scale.type);
    float time=0;
    for (int i=0; i<s.length; i++) {

      //if(duration[i]>=.25){
      s.duration[i]=1.5*duration[i]+time;
      s.melody[i]=melody[i]+INTERVALS[(int)random(INTERVALS.length)];
      time+=1.5*duration[i];
      //}
    }
    return s;
  }
  
  Sequence mergeSequence(Sequence s) {
    Sequence newSeq;
    if (s.length>length) {
      newSeq=new Sequence(s.length, scale.root, scale.type);
      for (int i=0; i<newSeq.length; i++) {
        if (i<length) {
          newSeq.melody[i]=((random(1)>0.5)? s.melody[i]:melody[i] );
          newSeq.duration[i]=((random(1)>0.5)? s.duration[i]:duration[i] );
        } else {
          newSeq.melody[i]=s.melody[i];
          newSeq.duration[i]=s.duration[i];
        }
      }
    } else {
      newSeq=new Sequence(length, scale.root, scale.type);
      for (int i=0; i<newSeq.length; i++) {
        if (i<s.length) {
          newSeq.melody[i]=((random(1)>0.5)? s.melody[i]:melody[i] );
          newSeq.duration[i]=((random(1)>0.5)? s.duration[i]:duration[i] );
        } else {
          newSeq.melody[i]=melody[i];
          newSeq.duration[i]=duration[i];
        }
      }
    }   
    return newSeq;
  }

  int[] reversePitches() {
    int[] newSeq=new int[melody.length];
    for (int i=0; i<melody.length; i++) {
      newSeq[i]=melody[length-1-i];
    }
    return newSeq;
  }

  float[] reverseDur() {
    float[] newSeq=new float[duration.length];
    for (int i=0; i<duration.length; i++) {
      newSeq[i]=duration[length-1-i];
    }
    return newSeq;
  }

  Sequence reverseNotes() {
    return new Sequence(reversePitches(), reverseDur(), scale.root, scale.type);
  }

  // flip midi, this is just a for-fun method
  Sequence invertPitches() {
    int[] newMel=new int[length];
    for (int i=0; i<melody.length; i++) {
      newMel[i]=127-melody[i];
    }
    newMel=fixer(newMel);
    return new Sequence(newMel, duration, scale.root, scale.type);
  }

  Sequence concat(Sequence s) {
    Sequence[] seqs=new Sequence[2];
    seqs[0]=this;
    seqs[1]=s;
    return new Sequence(seqs);
  }

  /* methods for reading and writing Sequences */
  void writeSequence() {
    PrintWriter w = createWriter("seq/"+day()+"-"+hour()+"-"+minute()+"-"+second()+".seq");
    w.println("Sequence");
    w.println(melody.length);
    w.println(scale.root);
    w.println(scale.type);      
    w.println(grid.baseDuration); // uh oh
    for (int i=0; i < melody.length; i++) {
      if(melody[i]==0); // do nothing
      else w.println(melody[i] + "," + duration[i]);
    }
    w.flush();
    w.close();
  }
 
  // Anna's Fixer function
  int[] fixer(int[] arg) {

    //make a copy of original (do not want to change original).
    int[] arr=new  int[arg.length];
    arrayCopy(arg, arr);

    //keep track of differences
    int diff1=200;  //for first
    int diff2=200;  //for last

    //indices 
    int ix1=0;     //index for new start value
    int ix2=0;     //index for new end value

    //orignal start and end vlaues
    int ft=arr[0];
    int lt=arr[arr.length-1];

    //Good start and end values
    int[] good= {
      55, 60, 67, 72, 79, 84, 91
    };
    int ln=good.length;


    //check for best start/end value
    for (int i=0; i<ln; i++) {

      //pick good start value closest to original
      if (abs(good[i]-ft)<diff1) {
        diff1=abs(good[i]-ft);
        ix1=i;
      }

      //pick good ending value closest to original
      if (abs(good[i]-lt)<diff2) {
        diff2=abs(good[i]-lt);
        ix2=i;
      }
    }

    //Change first value
    arr[0]=good[ix1];
    //Change last value  
    arr[arr.length-1]=good[ix2];
    return arr;
  }
  
  void setADSR(float[] array){
    this.adsr = array;
  }
  
  void setWaveform(Waveform waveform){
    this.wf = waveform;
  }

}
