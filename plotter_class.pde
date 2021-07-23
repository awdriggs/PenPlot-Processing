//  Simple plotter class
class Plotter {
  //properties
  Serial port;
  int xMin, yMin, xMax, yMax;
  float scale; //this is used to keep shit in porportion with proceessing

  //constructer
  Plotter(Serial _port, int _xMin, int _yMin, int _xMax, int _yMax, float _scale) {
    port = _port;
    xMin = _xMin;
    yMin = _yMin;
    xMax = _xMax;
    yMax = _yMax;
    scale = _scale;
    write("IN;"); //init the printer
  }

  //Internal Methods
  //used by class to build commands for the plotter
  void write(String hpgl) { //send a statment to the plotter
    if (PLOTTING_ENABLED) {
      port.write(hpgl);
    }
  }

  void write(String hpgl, int del) { //write with a delay, no be used to often in favor of building delays into the processing draw function
    if (PLOTTING_ENABLED) {
      port.write(hpgl);
      delay(del);
    }
  }

  float convert(float value) { //convert pixel value to plot value
    return value * scale;
  }

  float convertX(float value) { //convert pixel x value to plot x value
    return convert(value)+xMin; //new way of doing things, should have the same result, tested
    //return map(value, 0, width, xMin, xMax); //depracated method for converting value
  }

  float convertY(float value) { //convert pixel y value to plot y value
    return convert(value)+yMin;
  }

  //Plotter Utility Methods
  //select a pen
  void selectPen(int slot) {
    if (slot >= 0 && slot <= 6 ) {
      write("SP" + slot + ";");
    } else {
      println("Your pen selection of " +
          slot + " isn't a valid pen slot. Using default pen instead.");
    }
  }

  //Non-Drawing Coordinate Commands
  //send the pen to a location, engage true will put pen down, is this even a useful function?
  void sendTo(float x, float y, boolean engage){
    println("sendto called", x, y);
    String statement = "PU" + convertX(x) + "," + convertY(y) + ";";

    if(engage){
      statement += "PD;";
    }

    write(statement);
  }

  String fillType(int model){ //fill type 1 or 2, solid fill based on specified pen thickness
    String statement = "FT"+model+";";
    return statement;
  }

  String fillType(int model, float space, float angle){ //fill type 3(hatching) or 4(crosshatch),
    //assume that angle is given already in degrees
    String statement = "FT" + model + "," + convert(space) + "," + angle +";";
    return statement;
  }
   
  //line type
  
  //rotation plotter coordinate system
  /*
  //not working, printer is ignoring this command
  void rotatePlotter(float theta){ //assume theta is in radians
  float deg = degrees(theta);
  println(int(deg));
  String statement ="RO" + int(deg) + ";";
  println(statement);
  write(statement);
  }
   */

  //Drawing Commands

  //draw a single line, point to point
  void drawLine(float xStart, float yStart, float xEnd, float yEnd) {
    //build a statement string so that only one write needs to be made to the plotter
    //start the command, pen up, move to start location
    String statement = "PU" + convertX(xStart) + "," + convertY(yStart) + ";";

    //pen down, move to end location, put pen up
    statement += "PD" + convertX(xEnd) + "," + convertY(yEnd) + ";PU;";

    write(statement); //send the statement to the plotter
  }

  void drawTo(float x, float y){
    println("drawTo", x, y);
    //problem here???????
    String statement = "PD;PA" + convertX(x) + "," + convertY(y) + ";";
    if(DEBUG) println(statement);
    write(statement);
  }

  //draw a series of connected lines
  void drawLines(PVector[] vertices) {
    //start the statement, pen up and move to first location, pen down, ready for next location
    String statement = "PU"+ convertX(vertices[0].x) + "," + convertY(vertices[0].y) + ";PD";

    //loop through the rest of the locations, add the x and y coordinate for each to the statement
    for (int i = 1; i < vertices.length; i++) {
      float x = convertX(vertices[i].x);
      float y = convertY(vertices[i].y);

      statement += (x + "," + y);

      //if we aren't at the end, add a comma to add the next location
      if(i != vertices.length -1){
        statement += ","; //
      }
    }

    statement += ";PU;"; //close statement and pen up

    if(DEBUG) println(statement);
    write(statement); //send the statement to the plotter
  }

  //draw a circle at x, y, no input resolution given
  void drawCircle(float x, float y, float diam) {
    //convert the given pixel dimension to the printer dimensions
    float radius = convert(diam/2); 
    //put pen at x,y, draw a circle with specified radius
    String statement = "PA" + convertX(x) + "," + convertY(y) + ";" + "CI" + radius + ";";
    if(DEBUG) println(statement);
    write(statment);
  }

  //draw a circle at x, y with input resolution
  void drawCircle(float x, float y, float diam, float res) {
    //convert the given pixel dimension to the printer dimensions
    float radius = convert(diam/2); 
    //put pen at x,y, draw a circle with specified radius
    String statement = "PA" + convertX(x) + "," + convertY(y) + ";" + "CI" + radius + "," + res + ";";
    if(DEBUG) println(statement);
    write(statement);
  }

  //labels
  

  //draw a rect
  void drawRect(float x, float y, float w, float h){
    //ER40,40;
    //PA60,60;
    String statment = "";
    float xStart = convertX(x);
    float yStart = convertY(y);
    float xEnd = convert(w);
    float yEnd = convert(h);

    statement += "PU;PA" + xStart + "," + yStart + ";PD;" + "ER" + xEnd + "," + yEnd + ";PU;";

    if(DEBUG) println(statment);
    write(statement);
  }

  //fill rect, fill types 1 and 2
  void fillRect(float x, float y, float w, float h, int model){
    //setup the filltype
    String statement = "";
    statement += fillType(model);

    //setup the coordinates
    float xStart = convertX(x);
    float yStart = convertY(y);
    float xEnd = convert(w);
    float yEnd = convert(h);

    statement += "PU;" + convertX(xStart) + "," + convertY(yStart) + ";PD;";
    statement += "RR" + xEnd + "," + yEnd + ";PU;";

    if(DEBUG) println(statment);
    write(statement);
  }

  //fill rect, for filltypes 3 and 4 which need a spaceing and angle
  void fillRect(float x, float y, float w, float h, int model, float space, float angle){
    //ER40,40;
    //PA60,60;
    //setup the filltype
    String statement = "";
    statement += fillType(model,convert(space),angle);

    //setup the coordinates
    float xStart = convertX(x);
    float yStart = convertY(y);
    float xEnd = convert(w);
    float yEnd = convert(h);

    statement += "PU:" + convertX(xStart) + "," + convertY(yStart) + ";PD";
    statement += "RR" + xEnd + "," + yEnd + ";PU;";

    if(DEBUG) println(statment);
    write(statement);
  }

    //edge a polygon
  void drawPoly(PVector [] vertices) {

  }

  void drawPoly(ArrayList<PVector> vertices) {

  }

  //draw bounds
  //make a rect around the page
}
