//  Simple plotter class
class Plotter {
  //properties
  Serial port;
  int xMin, yMin, xMax, yMax;
  float scale; //this is used to stay in porportion with proceessing

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
  void lineType(){ //no params, reset to default 
    String statement = "LT;";
    if(DEBUG) println(statement);
    write(statement);
  }

  void lineType(int mode){ //space is a percent, of what i dont' know
    String statement = "LT" + mode + ";";
    if(DEBUG) println(statement);
    write(statement);
  }

  void lineType(int mode, float space){ //space is a percent, of what i dont' know
    String statement = "LT" + mode + "," + space + ";";
    if(DEBUG) println(statement);
    write(statement);
  }

  //rotation plotter coordinate system
  //right now only works with 90 degrees and messes up p2
  void rotatePlotter(int theta){
    /* float deg = int(degrees(theta)); */
    /* println(int(deg)); */
    String statement ="RO" + theta  + ";";
    if(DEBUG) println(statement);
    write(statement);
  }

  //Drawing Commands

  //draw a single line, point to point
  void drawLine(float xStart, float yStart, float xEnd, float yEnd) {
    //build a statement string so that only one write needs to be made to the plotter
    //start the command, pen up, move to start location
    String statement = "PU" + convertX(xStart) + "," + convertY(yStart) + ";";

    //pen down, move to end location, put pen up
    statement += "PD" + convertX(xEnd) + "," + convertY(yEnd) + ";PU;";

    if(DEBUG) println(statement);
    write(statement); //send the statement to the plotter
  }

  void drawTo(float x, float y){ //
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

  void drawLines(ArrayList<PVector> vertices) {
    PVector origin = vertices.get(0);
    String statement = "PU;PA"+ convertX(origin.x) + "," + convertY(origin.y) + ";";
    statement += "PD;"; //clear any polygon

    for (int i = 1; i < vertices.size(); i++) {
      float x = convertX(vertices.get(i).x);
      float y = convertY(vertices.get(i).y);

      statement += (x + "," + y);

      //if we aren't at the end, add a comma to add the next location
      if(i != vertices.size() -1){
        statement += ","; //
      }
    }

    statement += ";PU;"; //close statement and pen up

    if(DEBUG) println(statement);
    write(statement);
  }

  //draw a circle at x, y, no input resolution given
  void drawCircle(float x, float y, float diam) {
    //convert the given pixel dimension to the printer dimensions
    float radius = convert(diam/2);
    //put pen at x,y, draw a circle with specified radius
    String statement = "PA" + convertX(x) + "," + convertY(y) + ";" + "CI" + radius + ";";
    if(DEBUG) println(statement);
    write(statement);
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

  //filltype 1 or 2
  void fillCircle(float _x, float _y, float diam, int model) {
    float radius = convert(diam/2);
    float x = convertX(_x);
    float y = convertY(_y);

    String statement = "PU;PA" + x + "," + y + ";"; //put pen at circle center xy
    statement += fillType(model); //setup fill
    write(statement);
  }

  //filltype 3 or 4
  void fillCircle(float _x, float _y, float diam, int model, float space, float angle){
    float radius = convert(diam/2);
    float x = convertX(_x);
    float y = convertY(_y);

    String statement = "PU;PA" + x + "," + y + ";"; //put pen at circle center xy
    statement += fillType(model,convert(space),angle); //setup fill
    statement += "WG" + radius + ",0,360;"; //uses the wedge command to draw a circle

    if(DEBUG) println(statement);
    write(statement);
  }

  //wedges
  void drawWedge(float _x, float _y, float _dia, float _startAngle, float _sweepAngle){
    float x = convertX(_x);
    float y = convertY(_y);
    float radius = convert(_dia)/2;
    
    //assume that angles are in radians
    int startAngle = int(degrees(_startAngle)); //convert from radians to degrees
    int sweepAngle = int(degrees(_sweepAngle)); //this is the sweep of the angle 

    String statement = "PU; PA" + x + "," + y + ";";
    statement += "EW" + radius + "," + startAngle + "," + sweepAngle + ";";

    if(DEBUG) println(statement);
    write(statement);
  }

  //fill model 1/2
  void fillWedge(float _x, float _y, float _dia, float _startAngle, float _sweepAngle, int model) {
    float x = convertX(_x);
    float y = convertY(_y);
    float radius = convert(_dia)/2;

    int startAngle = int(degrees(_startAngle)); //convert from radians to degrees
    int sweepAngle = int(degrees(_sweepAngle)); //this is the sweep of the angle 

    String statement = "PU;PA" + x + "," + y + ";"; //put pen at circle center xy
    statement += fillType(model); //setup fill
    statement += "WG" + radius + "," + startAngle + "," + sweepAngle + ";";

    if(DEBUG) println(statement);
    write(statement);
  }

  //fill model 3/4
  void fillWedge(float _x, float _y, float _dia, float _startAngle, float _sweepAngle, int model, float space, float angle) {
    float x = convertX(_x);
    float y = convertY(_y);
    float radius = convert(_dia)/2;

    int startAngle = int(degrees(_startAngle)); //convert from radians to degrees
    int sweepAngle = int(degrees(_sweepAngle)); //this is the sweep of the angle 

    String statement = "PU;PA" + x + "," + y + ";"; //put pen at circle center xy
    statement += fillType(model,convert(space),angle); //setup fill
    statement += "WG" + radius + "," + startAngle + "," + sweepAngle + ";";

    if(DEBUG) println(statement);
    write(statement);
  }

  //draw a rect
  void drawRect(float x, float y, float w, float h){
    String statement = "";
    float xStart = convertX(x);
    float yStart = convertY(y);
    float xEnd = convert(w);
    float yEnd = convert(h);

    statement += "PU;PA" + xStart + "," + yStart + ";PD;" + "ER" + xEnd + "," + yEnd + ";PU;";

    if(DEBUG) println(statement);
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

    statement += "PU;PA" + xStart + "," + yStart + ";PD;";
    statement += "RR" + xEnd + "," + yEnd + ";PU;";

    if(DEBUG) println(statement);
    write(statement);
  }

  //fill rect, for filltypes 3 and 4 which need a spaceing and angle
  void fillRect(float x, float y, float w, float h, int model, float space, float angle){
    //setup the filltype
    String statement = "";
    statement += fillType(model,convert(space),angle);

    //setup the coordinates
    float xStart = convertX(x);
    float yStart = convertY(y);
    float xEnd = convert(w);
    float yEnd = convert(h);

    statement += "PU:" + xStart + "," + yStart + ";PD";
    statement += "RR" + xEnd + "," + yEnd + ";PU;";

    if(DEBUG) println(statement);
    write(statement);
  }

  //edge a polygon
  //note, you could refactor these to draw from last vertext to first, sould save a line of code
  void drawPoly(PVector[] vertices) {
    String statement = "PU;PA"+ convertX(vertices[0].x) + "," + convertY(vertices[0].y) + ";";
    statement += "PM0;PD;"; //clear any polygon

    /* //loop through the rest of the locations, add the x and y coordinate for each to the statement */
    for (int i = 0; i < vertices.length; i++) {
      float x = convertX(vertices[i].x);
      float y = convertY(vertices[i].y);

      statement += ("PA" + x + "," + y + ";");
    }

    //return to start
    statement += "PA"+ convertX(vertices[0].x) + "," + convertY(vertices[0].y) + ";";
    statement += "PU;PM2;EP;"; //pen up, close polygon

    if(DEBUG) println(statement);
    write(statement); //send the statement to the plotter
  }

  //draw a polygon from an array list of pvectors
  void drawPoly(ArrayList<PVector> vertices) {
    PVector origin = vertices.get(0);
    String statement = "PU;PA" + convertX(origin.x) + "," + convertY(origin.y) + ";";
    statement += "PM0;PD;"; //clear any polygon

    for (PVector v : vertices) {
      statement += ("PA" + convertX(v.x) + "," + convertY(v.y) + ";");
    }

    //return to start
    statement += "PA" + convertX(origin.x) + "," + convertY(origin.y) + ";";
    statement += "PU;PM2;EP;"; //pen up, close polygon

    if(DEBUG) println(statement);
    write(statement); //send the statement to the plotter
  }

  //make a polygon method that takes in a pShape, untested
  void drawShape(PShape s){
    PVector origin = s.getVertex(0);
    String statement = "PU;PA" + convertX(origin.x) + "," + convertY(origin.y) + ";";
    statement += "PM0;PD;"; //clear any polygon and start polygon mode

    //getVertexCount()  Returns the total number of vertices as an int
    for (int i = 0; i < s.getVertexCount(); i++) {
      PVector v = s.getVertex(i); //current vertex
      statement += ("PA" + convertX(v.x) + "," + convertY(v.y) + ";");
    }

    //return to start
    statement += "PA" + convertX(origin.x) + "," + convertY(origin.y) + ";";
    statement += "PU;PM2;EP;"; //pen up, close polygon

    if(DEBUG) println(statement);
    write(statement); //send the statement to the plotter
  }

  //doesn't seem to work with HPGL1 and the 7475A
  void fillPoly(PVector[] vertices, int model, float space, float angle){
    //define poly with pen up, then fill?
    String statement = "PU;PA"+ convertX(vertices[0].x) + "," + convertY(vertices[0].y) + ";";

    statement += "PM0;"; //clear any polygon, don't put pen down?

    for (int i = 1; i < vertices.length; i++) {
      float x = convertX(vertices[i].x);
      float y = convertY(vertices[i].y);

      statement += ("PA" + x + "," + y + ";");
    }

    statement += "PM2;"; //pen up, fill polygon
    statement += fillType(model, convert(space), angle);
    statement += "FP;"; //pen up, fill polygon

    if(DEBUG) println(statement);
    write(statement); //send the statement to the plotter

  }

  //doesn't seem to work with HPGL1 and the 7475A
  void fillPoly(ArrayList<PVector> vertices, int model, float space, float angle){
    //define poly with pen up, then fill?
    PVector origin = vertices.get(0);
    String statement = "PU;PA" + convertX(origin.x) + "," + convertY(origin.y) + ";";
    statement += "PM0;"; //clear any polygon, don't put pen down?

    for (PVector v : vertices) {
      statement += ("PA" + convertX(v.x) + "," + convertY(v.y) + ";");
    }

    statement += "PA" + convertX(origin.x) + "," + convertY(origin.y) + ";";
    statement += "PM1;"; //pen up, fill polygon
    statement += "PM2;"; //pen up, fill polygon
    statement += fillType(model, int(convert(space)), angle);
    statement += "FP;"; //pen up, fill polygon

    if(DEBUG) println(statement);
    write(statement); //send the statement to the plotter

  }

  //not working with my plotter 
  void fillPoly(ArrayList<PVector> vertices, int model){
    //define poly with pen up, then fill?
    PVector origin = vertices.get(0);
    String statement = "PU;PA" + convertX(origin.x) + "," + convertY(origin.y) + ";";
    statement += "PM0;"; //clear any polygon, don't put pen down?

    for (PVector v : vertices) {
      statement += ("PA" + convertX(v.x) + "," + convertY(v.y) + ";");
    }

    statement += "PA" + convertX(origin.x) + "," + convertY(origin.y) + ";";
    statement += "PM1;"; //pen up, fill polygon
    statement += "PM2;"; //pen up, fill polygon
    statement += fillType(model);
    statement += "FP;"; //pen up, fill polygon

    if(DEBUG) println(statement);
    write(statement); 

  }

  //Arc
  void drawArc(float _x, float _y, float _size, float _start, float _end) {
    float x = convertX(_x);
    float y = convertY(_y);
    float radius = convert(_size)/2;

    int sweep = int(degrees(_end - _start)); //this is the sweep of the angle 

    //in hpgl present location becomes the start of the sweep
    //calculate where the pen should start 
    float yStart = sin(_start) * radius + y; 
    float xStart = cos(_start) * radius + x; 
     
    //send the pen to the start location
    String statement = "PU;PA" + xStart + "," + yStart + ";PD;";
    statement += "AA" + x + "," + y + "," + sweep + ";PU;";

    if(DEBUG) println(statement);
    write(statement);
  }

  //Labels
  void label(String text, float _x, float _y){
    float x = convertX(_x);
    float y = convertY(_y);

    String statement = "PU;PA" + x + "," + y + ";";
    statement += "SS;";
     
    float tWidth = g.textSize * 0.0264;  //set label width to global text size, pixel to cm conversion
    float tHeight = tWidth * 1.32; //based on HPGL default, height is 1.32 times the width, so testing that
    statement += "SI" + tWidth + "," + tHeight + ";"; 
    statement += "LB" + text + char(3); 

    if(DEBUG) println(statement);
    write(statement);
  }
}
