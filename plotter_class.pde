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
    if (PLOTTING_ENABLED) {
      port.write(hpgl);
    }
  }

  void write(String hpgl, int del) {
    if (PLOTTING_ENABLED) {
      port.write(hpgl);
      delay(del);
    }
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

  void movePen(float _x, float _y) {
    //map input to paper size
    float x = map(_x, 0, width, xMin, xMax);
    float y = map(_y, 0, height, yMin, yMax);
    write("PA" + x + "," + y + ";");
  }

  //draw a line
  //void drawLine(float _x1, float _y1, float _x2, float _y2) {
  //  //map input to paper size
  //  float x1 = map(_x1, 0, width, xMin, xMax);
  //  float y1 = map(_y1, 0, height, yMin, yMax);
  //  float x2 = map(_x2, 0, width, xMin, xMax);
  //  float y2 = map(_y2, 0, height, yMin, yMax);

  //  //pick up pen and go to x1, y1
  //  write("PU" + x1 + "," + y1 + ";");

  //  //put down pen and go to x2, y2
  //  write("PD" + x2 + "," + y2 + ";");

  //  //pick up pen
  //  write("PU;");
  //}

  ////draw a line
  //void drawLines(PVector[] vertices) {

  //}

  //draw a line
  void drawLine(float xStart, float yStart, float xEnd, float yEnd) {
    write("PU;");
    movePen(xStart, yStart);
    write("PD;");
    movePen(xEnd, yEnd);
    write("PU;");
  }

  //draw a line
  void drawLines(PVector[] vertices) {
    //move to first location
    write("PU;");
    movePen(vertices[0].x, vertices[0].y);
    write("PD;");

    //loop the array, starting at the 2nd index
    for (int i = 1; i < vertices.length; i++) {
      movePen(vertices[i].x, vertices[i].y);
    }
    //end, pick up the pen
    write("PU;");
  }
  //draw a line from a series of vectors

  //label

  //fill type

  //line type

  //draw a rect

  //draw a filled rect

  //draw a polygon

  //draw bounds
  //make a rect around the page
}