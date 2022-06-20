// Grid Music - Probablistic Composition tool (beta)
// Author: Nels Oscar
// Mar 2011
// I should have thought of this earlier.
// Goal is to replace int/float arrays used in Sequence,etc. with Note objects

class Note {

  int pitch;      // MIDI value
  float duration; // relative duration (1 = quarter note)

  Note(int p, float d) {
    pitch    = p;
    duration = d;
  }
}
