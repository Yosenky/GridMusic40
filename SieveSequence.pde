/* 
 * SieveSequence
 * Version v.01 (7/22)
 */

class SieveSequence extends Sequence {

  // initial value should be played around with
  double recur = 0.5;   // starting value of x for CMY_Polynomial poly (try 0.5)
  boolean version2 = true;
  Polynomial poly = new Polynomial (0);

  public SieveSequence(int numNotes, int root, int type, float try_recur) {
    super(numNotes, root, type);
    recur = try_recur;
  }

  Note getNextNote() {
    Note n;

    numNotesGot++;

    if (!version2) {
      // Sabria v.1
      float i = 0.01*numNotesGot;
      recur =  poly.eval (i);
      int bigRecur = (int) (recur * 1000);

      // result is pitches cascading down to 0, because bigRecur is falling from 9999 down to inflection point
      // on the bifurcation graph, then things get (briefly) more chaotic 

      n=new Note(abs(scale.notes[abs(bigRecur%scale.notes.length)]), duration[abs(currPos%length)]);
    } else {
      // Sabria v.2
      // works only when i < 2, or numNotesGot < 2000, otherwise min recur goes to infinity
      float i = (2.0/120)*numNotesGot;                    // magic number 120 should be EXPLEN, got some results with 2.0/120*numNotesGot
      recur =  poly.eval (i);
      double bigRecur = recur * 10000;
      // kludge for keeping things sane (!!!)
      if (bigRecur > 9000) bigRecur -= 5000;
      println(numNotesGot + ": " + bigRecur);
      //bigRecur = bigRecur%10000;        // forcing to to stay within +/-10000

      // found the max and min for bigRecur from CMT_Client
      int mapRecur = (int) map((int) bigRecur, -10000, 10000, 1, 127);

      n = new Note (mapRecur, duration[abs(currPos%length)]);
    }

    return n;
  }
}
