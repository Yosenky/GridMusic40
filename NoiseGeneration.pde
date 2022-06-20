// Noise Generation Class
// Currently implements brownian noise (1/f^2)
// In Progress: Pink Noise(1/f)

class NoiseGeneration{

  Grid grid;
  
  NoiseGeneration(Grid grid){
    this.grid = grid;
  }
  
  // Generates brownian noise, noiseRange is the range (in MIDI values) of the noise
  void generateBrownianNoise(float noiseRange){
    for(int i = 0; i < grid.getGrid().length; i++){
      //grid.getGrid[0].length/3 is "middle C", then we add noise int(random(-3,3))
      grid.getGrid()[i][(grid.getGrid()[0].length/3) + int(random(-3,3))].isset = true;
    }
    grid.play(noiseRange);
  }
  
  // Generates pink noise over the span of an octave, starting at startingMIDI midi value
  void generatePinkNoise(int startingMIDI){
    int randomNoiseValue = 0;
    boolean redDice = false;
    boolean blueDice = false;
    boolean greenDice = false;
    for(int i = 0; i < grid.getGrid().length; i++){
      if(redDice){
        randomNoiseValue += (int)(random(0,5));
      }
      if(redDice){
        randomNoiseValue += (int)(random(0,5));
      }
      if(redDice){
        randomNoiseValue += (int)(random(0,5));
      }

      
    }
  }
  
}
