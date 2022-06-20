// Grid Music - Probablistic Composition tool (beta)
// Author: Nels Oscar
// Mar 2011
// Modified: spc, 9/13, 5/15

// Generates 128 notes of a scale in a lookup table of notes
// #Bug# nao 2/22/11
// -- I've noticed that it has a null pointer when
//    the 0th note is requested


class Scale {

  // root pitch, type of scale or mode
  int root;
  int type;

  // given a root pitch, RULEs are used to generate one of several possible scales/modes
  // #Bug# charles - nao includes the initial note in the set. This will create a double note between octaves.
  //       i.e. you had this {0, 2, 2, 1, 2, 2, 2, 1}  you want this  {0, 2, 2, 1, 2, 2, 2}
  int[][] RULE= {
    {2, 2, 1, 2, 2, 2, 1}
    , // major scale
    {2, 1, 2, 2, 1, 2, 2}
    , // minor scale
    {2, 2, 3, 2}
    , // pentatonic scale
    {2, 2, 2, 2, 2}
    , // whole tone scale
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
    , // chromatic scale
    {2, 1, 2, 1, 2, 1, 2}
    , // octa scale
    {2, 2, 2, 2, 2}
    , // Messiaen scale the 1st
    {2, 1, 2, 1, 2, 1, 2}
    , // Messiaen scale the 2nd
    {2, 1, 1, 2, 1, 1, 2, 1}
    , // Messiaen scale the 3rd
    {1, 1, 3, 1, 1, 1, 3}
    , // Messiaen scale the 4th
    {1, 4, 1, 1, 4}
    , // Messiaen scale the 5th
    {2, 2, 1, 1, 2, 2, 1}
    , // Messiaen scale the 6th
    {1, 1, 1, 2, 1, 1, 1, 1, 2}
    , // Messiaen scale the 7th
    {2, 2, 1, 2, 2, 2}
    , // ionic mode
    {2, 2, 1, 1, 2, 2, 1}
    , // dorian mode
    {1, 1, 1, 2, 1, 1, 1, 1, 2}
    , // phyrgian mode
    {2, 2, 2, 1, 2, 2, 1}
    , // lydian mode (is just a natural diatonic transformation from F-F -charles)
    {2, 1, 2, 2, 2, 1, 2}
    , // lydian-mixoylydian mode
    {1, 2, 2, 2, 1, 2, 2}
    , // mixoylydian mode
    {2, 2, 2, 1, 2, 2, 1}
    , // aeolian mode
    {2, 1, 2, 1, 2, 1, 2}
    , // locian mode
    {2, 2, 1, 2, 2, 1, 2}
    , // lydian mode?
    {2, 1, 2, 2, 1, 2, 2}
    , // lydian mode?
    {1, 2, 2, 1, 2, 2, 2}         
      // lydian mode?
  };

  int[] notes;

  // Constructor - generates scale based on root tone and scale type
  Scale(int root, int type) {
    this.root=root;
    this.type=type;
    notes=generateScale(root, type);
  }

  // generateScale - does the heavy lifting of initializing notes with the scale
  int [] generateScale(int root, int type) {
    int i;
    int[] newNotes=new int[128];

    newNotes[0] = root;
    for (i=1; i < newNotes.length && newNotes[i-1] < 100; i++) { 
      newNotes[i] = newNotes[i-1] + RULE[type][i % RULE[type].length];
    }

    int[] finalNotes=new int[i];
    for (i=0; i<finalNotes.length; i++) {
      finalNotes[i] = newNotes[i];
    }
    return finalNotes;
  }

  // getRandomNote - generate a random pitch from the scale
  int getRandomNote() {
    return notes[(int)random(notes.length)];
  }
}
