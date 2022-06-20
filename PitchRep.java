/** PitchRep - class for building and accessing a map of MIDI pitch values to note names and / or frequencies
    Intended to be used as a Singleton
    @author spc
    @version 0.1
*/

public class PitchRep {
    
    // inner class for representations
    private class Reps { 
  String name;  // pitch name, e.g. "C4" or "G#" 
  double freq;  // frequency associated with the pitch
    };

    protected Reps[] pitches = new Reps[128]; // pitches array is indexed (0 through 128) by MIDI pitch values
    protected String[] names = new String[128];

    public PitchRep() {  
  generateNames();

  // for each MIDI value used
  for (int i = 0; i < 128; i++) {
      Reps pitch = new Reps();
      pitch.name = names[i];
      pitch.freq = PitchRep.mtof(i);
      pitches[i] = pitch;
  }
    }

    /** generateNames - generate note names C0 through C8 corresponding to MIDI values
     */
    protected void generateNames() {
  String[] notenames = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
  int designation = 0;

  for (int i = 0; i < 128; i++) {
      if (i % 12 == 0 && i != 0) designation++;
      names[i] = notenames[i%12] + designation;
  } 
    }
  
    /** mtof - MIDI pitch value to frequency (exactly like the one from Pd) */
    public static double mtof(int midi) {
      return 440 * Math.pow(2, ((midi - 69) / 12.0));
    }

    public String getName(int midi) {
  return pitches[midi].name;
    }

    public double getFreq(int midi) {
  return pitches[midi].freq;
    }

    // Quick Test Program
    public static void main(String[] args){
  PitchRep pr = new PitchRep();
  
  for (int midival = 0; midival < 128; midival++) {
      System.out.println(pr.getName(midival));
      System.out.println(pr.getFreq(midival));
  }
    }
};
