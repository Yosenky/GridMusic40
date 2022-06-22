// Controller for the plot display

class PlotController{
  
  public PlotController(){
  }
  
  
  void clearPlot(){
    // getPoints() returns a GPoints array for the graph
    // getNPoints() returns the size of the GPoints array
    while(plot.getPoints().getNPoints() > 0){
      plot.removePoint(0);
    }
  }
  
}
