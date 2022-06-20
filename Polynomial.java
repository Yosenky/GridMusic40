/**
 * Polynomial Class (adapted from Eventful Java Ex. 14.9.3)
 * Sabria Farheen
 * May 30, 2011
 */

public class Polynomial {

    // coef[i] is the coefficient of x to the ith power
    protected double [] coef;
    
    public Polynomial (int degree) {
        if (degree >= 0)
            coef = new double [degree+1];
    }
    
    /* parameter is a 2D array with each row containing 
       the value of the coefficient and the degree in that order
       MUST provide coefficients for all degrees!*/
    public Polynomial (double [][] coef2D) {
        if (coef2D.length > 0 && coef2D[0].length == 2){
            coef = new double [coef2D.length];
            for (int i=0; i < coef2D.length ; i++) {
                int index = (int) coef2D[i][1];
                double value = coef2D[i][0];
                coef[index] = value;
            }
        }
            
    }
    
    // parameter is a list of coefficients starting with that of x^0
    public Polynomial (double [] coefList) {
        if (coefList.length > 0) {
            coef = new double [coefList.length];
            coef = coefList;
        }
    }
    
    // set the value of the coefficient of x to the ith
    public void setCoef (double value, int i) {
        if (i >= 0 && i < coef.length) {
            coef[i] = value;
        }
    }
    
    public double eval (double x) {
        double result = coef[0];
        double power = x;
        
        for (int i = 1; i < coef.length; i++) {
            result = result + power * coef[i];
            power = power * x;
        }
        return result; 
    }
    
    //public double eval2 (double x, double r) {
    // i think this method should be in an extended class
    // DO IT!!!
      //  return 2;
    //}
    
    public String toString() {
        String result = "";
        
        for (int i = 0; i < coef.length; i++) {
                if (coef[i] > 0) 
                    result = result + " + " + coef[i] + "x^" + i;
                else if (coef[i] < 0)
                    result = result + " - " + (coef[i]*-1) + "x^" + i;       
                
            }
        return result;
        
        }
    

    
}
