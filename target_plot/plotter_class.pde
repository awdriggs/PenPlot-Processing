//  Simple plotter class

class Plotter {
  //properties
  Serial port;
  int xMin, yMin, xMax, yMax;

  //constructer
  Plotter(Serial _port, int _xMin, int _yMin, int _xMax, int _yMax) {
    port = _port;
    xMin = _xMin;
    yMin = _yMin;
    xMax = _xMax;
    yMax = _yMax;

    //init the printer
    write("IN;");
  }

  //methods
  void write(String hpgl) {
      port.write(hpgl);
  }

  void write(String hpgl, int del) {
      port.write(hpgl);
      delay(del);
  }

  void endPrint() {
    write("PA0,0;SP0;");
  }

  //select a pen
  void selectPen(int slot) {
    if (slot >= 0 && slot <= 6 ) {
      write("SP" + slot + ";");
    } else {
      println("Your pen selection of " +
          slot + " isn't a valid pen slot. Using default pen instead.");
    }
  }

  float convertX(float value) {
    return map(value, 0, width, xMin, xMax);
  }

  float convertY(float value) {
    return map(value, 0, height, yMin, yMax);
  }

  //draw a line
  void drawLine(float xStart, float yStart, float xEnd, float yEnd) {
    //build a statement string so that only one write needs to be made to the plotter
    //start the command, pen up, move to start location
    String statement = "PU" + convertX(xStart) + "," + convertY(yStart) + ";";

    //pen down, move to end location, put pen up
    statement += "PD" + convertX(xEnd) + "," + convertY(yEnd) + ";PU;";

    //send the statement to the plotter
    write(statement);
  }

  //draw a series of connected lines
  void drawLines(PVector[] vertices) {
    //build a statement string so that only one write needs to be made to the plotter

    //start thes statment, pen up and move to first location, pen down, ready for next location
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

    //add the closing semi-colon
    statement += ";"; //closing command

    //println(statement); //for debug

    //send the statement to the plotter
    write(statement);
  }

  //draw an cirlce 
  //draw a circle at x, y with input resolution
  void drawCircle(float x, float y, float diam, float res) {

    //convert the given pixel dimension to the printer dimensions
    float radius = map(diam/2, 0, width, 0, xMax-xMin);

    println(radius);
    //PAx,y; CIradius,res; //move to x, y and draw a circle
    write("PA" + convertX(x) + "," + convertY(y) + ";" + "CI" + radius + "," + res + ";");
  }

  //label

  //fill type

  //line type

  //draw a rect

  //draw a filled rect

  //draw a polygon

  //draw bounds
  //make a rect around the page
}
