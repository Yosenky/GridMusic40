/**
 * Creates Polynomial strictly of the form 1 - rx^2
 * 
 * Sabria Farheen 
 * June 5, 2011
 */

public class CMT_Polynomial extends Polynomial {

  public CMT_Polynomial (double r) {
    super (2);
    super.setCoef (1, 0);
    super.setCoef (-1*r, 2);
  }

  // sets the coefficiant of the x-squared term
  public void setr (double value) {
    super.coef[2] = value*-1;
  }

  // gets the coefficiant of the x-squared term
  public double getr() {
    return super.coef[2]*-1;
  }

  public double evalCMT(double x, double r) {

    return 1 - r * x*x;

    /* alternative code could be:
     setr(r);
     super.eval(value);
     */
  }
}
