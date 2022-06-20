// Modified by stehnce0 2/28/17 fixed audio clipping, replacing multiplier with ADSR

class ToneInstrument implements Instrument
{
  Oscil sinOsc;
  AudioOutput out;
  ADSR adsr;
  
  ToneInstrument( float frequency, float amplitude, AudioOutput output, float[] opts, Waveform wf)
  {
    out = output;
    sinOsc = new Oscil( frequency, amplitude, wf);
    adsr = new ADSR( 0.1, opts[0], opts[1], opts[2], opts[3]);
    sinOsc.patch( adsr );
  }
 
  void noteOn( float dur )
  { 
    adsr.patch( out );
    adsr.noteOn();
  }
 
  void noteOff()
  { 
    adsr.noteOff();
    adsr.unpatchAfterRelease( out ); 
  }
}
