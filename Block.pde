// Grid Music - Probablistic Composition tool (beta)
// Author: Nels Oscar
// Mar 2011
// Edited 6/6/22 - 7/15-22 jrkm

class Block {

  PVector pos, s;
  int pitch, on, off, active, col;
  float duration;
  boolean isset=false;
  boolean isActive = false; // is it the note currently being played?
  PShape rectangle;

  Block(PVector pos, PVector s, int note, float dur) {
    this.pos=pos;
    this.s=s;
    pitch=note;
    duration=dur;
    on=color(0, 255, 0);
    off=color(0, 100, 200);
    active=color(232,252,10);
  }

  void show() {
    rectMode(CENTER);
    col= isset ? color(on) : color(off);
    fill(col);
    if(isActive){
      fill(active);
    }
    rectangle = createShape(RECT,pos.x, pos.y, s.x, s.y);
    shape(rectangle);
  }
  
  void resize(int newWidth, int newHeight){
    s.x = newWidth;
    s.y = newHeight;
    show();
  }

  boolean isSet() {
    return this.isset;
  }

  // Attempting to change color of block that is active(currently playing)
  void activate(){
    isActive = true;
    show();
  }
  
  boolean isActivated(){
    return isActive;
  }
  

  boolean contains(PVector v) {
    if (v.x<=pos.x+s.x/2. && v.x>=pos.x-s.x/2. &&
      v.y<=pos.y+s.y/2. && v.y>=pos.y-s.y/2. ) {
      isset=!isset;   
      return true;
    } else {
      return false;
    }
  }
}
