import processing.serial.*;

Serial myPort;    // Create object from Serial class
Plotter plotter;  // Create a plotter object
int val;          // Data received from the serial port, needed?

//Enable plotting? //toggle for debug
final boolean PLOTTING_ENABLED = true;
final boolean DEBUG = true;

//Label
String label = "TEST";

//Plotter dimensions
int xMin, yMin, xMax, yMax;

float scale = 10; //used to keep processing window in proportion to paper size
//note on scaling. 1px gets scaled to 1 plotter unit. 1 plotter unit = 0.025mm?
//test this out 10px = 100plots = 2.5mm
void settings(){
  // Set the paper size first, this allows the preview window to be in proportion
  // "A" = letter size, "B" = tabloid size, "A4" = metric A4, "A3" = metric A3
  setPaper("A");

  println("print dimensions", xMin, yMin, xMax, yMax);
  
  // Calculate the processing canvas size, proportional to paper size
  float screenWidth = (xMax - xMin)/scale;
  float screenHeight = (yMax - yMin)/scale;

  //set the canvas size depending on the paper size that will be used...
  size(int(screenWidth), int(screenHeight));
  println("screen dimensions", width, height);
}

void setup(){ //Let's set up ports and plotter 
  //select a serial port
  if(PLOTTING_ENABLED){
    println(Serial.list()); //Print all serial ports to the console

    String portName = Serial.list()[5]; //make sure you pick the right one
    /* String portName = Serial.list()[3]; //make sure you pick the right one */
    println("Plotting to port: " + portName);

    myPort = new Serial(this, portName, 9600); //opens the port

    //create a plotter object, let the printer know the papersize and scale
    plotter = new Plotter(myPort, xMin, yMin, xMax, yMax, scale);
  }
  noLoop(); //kill the loop, otherwise your print will never end, but maybe that's what you want ;)
}

void draw(){
  println("drawing");
  //plotter.write("PU100,100;");
  //plotter.write("PD500,0,500,500,0,500,0,0;");
  /* println("50 px test..." + plotter.convertX(50)); */
  /*
     plotter.write("CT0;PA0,0;CI5;");
     plotter.write("CT0;PA100,0;CI5;");
     plotter.write("CT0;PA100,100;CI5;");
     plotter.write("CT0;PA0,100;CI5;");
   */

  //plotter.write("PA0,0;EA100,100;");
  //plotter.write("SI0.14,0.14;DI0,1;LBzero, zero" + char(3)); //Draw label

  //plotter.write("SP0;");
  //plotter.write("PG;");

  //test it! draws a li

  /* if(PLOTTING_ENABLED) plotter.selectPen(1); //pick a pen */
  /* plotter.write("PU410,596;PD410,4196,410,7796;"); */

  /* line(0, height/2, width, height/2); */
  /* plotter.drawLine(0, height/2, width, height/2); */
  /* plotter.drawLine(0, 0, width, 0); */
  /* plotter.drawLine(0, height, width, height); */
  //line(width/2, 0,width/2, height);
  //plotter.drawLine(width/2, 0, width/2, height);

  //PVector[] list = new PVector[3];
  //list[0] = new PVector(0, 0);
  //list[1] = new PVector(width/2, height/2);
  //list[2] = new PVector(width, 0);

  //plotter.drawLines(list);

  //testing a circle
  /* noFill(); */
  /* ellipse(width/2, height/2, 50, 50); */
  /* plotter.drawCircle(width/2, height/2, 50, 10); */

  /* if(PLOTTING_ENABLED) plotter.drawRect(0, 0, 10, 100); */
  /* if(PLOTTING_ENABLED) plotter.drawRect(0, 0, 250, 250); */
  /* if(PLOTTING_ENABLED) plotter.fillRect(0, 0, 250, 250, 4, 10, 45); */
  /* plotter.drawCircle(width, height, 10, 10); */
  /* plotter.drawCircle(0, 0, 10, 10); */
  /* plotter.fillRect(0, 0, 10, 10, 2); */

  //test rotate
  /* pushMatrix(); */
  /* translate(width/2, height/2); */
  /* rotate(QUARTER_PI); */
  /* rect(0, 0, 100, 100); */

  /* plotter.drawRect(screenX(0,0), screenY(0,0), 100, 100); */
  /* plotter.drawLine(0, height/2, width, height/2); */ 
  //when rotating, you will need to use polygon instead of a rect
  //or rotate the plot window?
  /* popMatrix(); */
  /* plotter.rotatePlotter(0); */

  //need to test
  //drawpoly with an array
  /* PVector test[] = new PVector[5]; */
  /* test[0] = new PVector(0, 0); */
  /* test[1] = new PVector(100, 50); */
  /* test[2] = new PVector(150, 100); */ 
  /* test[3] = new PVector(75, 150); */
  /* test[4] = new PVector(0, 75); */

  /* plotter.drawPoly(test); */  
  /* delay(1000); */
  /* plotter.fillPoly(test, 4, 0.1, 45); */
  /* ArrayList<PVector> test = new ArrayList<PVector>(); */
  /* test.add(new PVector(0, 0)); */
  /* test.add(new PVector(100, 50)); */
  /* test.add(new PVector(150, 100)); */
  /* test.add(new PVector(75, 150)); */
  /* test.add(new PVector(0, 75)); */

  /* plotter.rotatePlotter(90); */
  /* plotter.drawPoly(test); */  
  /* delay(1000); */
  /* plotter.fillPoly(test, 4, 2, 45); //not working */
   
  /* plotter.fillPoly(test, 1); */

  //drawpoly with an arraylist
  //drawlines with an arraylist
  //fill poly array
  //fill poly arrayList

  //fill a circle
  /* ellipse(200, 100, 100, 100); */
  /* plotter.drawCircle(200, 100, 100); */
  /* delay(2000); */ 
  /* plotter.fillCircle(200, 100, 100, 4, 1, 90); */
  
  //draw a wedge
  /* plotter.drawWedge(300, 100, 100, 0, 60); */
  //fill a wedge
  /* plotter.fillWedge(300, 100, 100, 0, 60, 4, 2, 45); */

  //line type
  /* for(int i = 0; i < 7; i++){ */
  /* plotter.lineType(i, 8); */
  /* plotter.drawLine(0, i*100, width, i*100); */
  /* delay(500); */
  /* } */
  
  //draw an arc
  //procesing
  /* float cx = width/2; */
  /* float cy = height/2; */

  /* float angle1 = 0; */
  /* float angle2 = 1.75 * PI; */
  
  /* arc(cx, cy, 500, 500, angle1, angle2); */
  /* plotter.drawArc(cx, cy, 500, angle1, angle2); //test this shit out! */ 

  //test your math
  /* float sweep = angle1 - angle2; */
  /* float sx = cos(angle1) * 100/2 + cx; */ 
  /* println(sx); */

  /* float sy = sin(angle1) * 100/2 + cy; */ 
  /* println(sy); */
   
  /* ellipse(sx, sy, 100, 100); */ 
  /* plotter.drawCircle(sx, sy, 100); */
  //test labels
  textSize(20);
  text("hello world", 200, 200);
  plotter.label("hello world", 0, 0);
  //end the printing

  plotter.drawCircle(width/2, height/2, 50, 10);

}

// set the global paper size
void setPaper(String size){
  if (size == "A") {
    xMin = 250;
    yMin = 596;
    xMax = 10250;
    yMax = 7796;
  } else if (size == "B") {
    xMin = 522;
    yMin = 259;
    xMax = 15722;
    yMax = 10259;
  } else if (size == "A3") {
    xMin = 170;
    yMin = 602;
    xMax = 15370;
    yMax = 10602;
  } else if (size == "A4") {
    xMin = 603;
    yMin = 521;
    xMax = 10603;
    yMax = 7721;
  } else {
    println("A valid paper size wasn't given to your Plotter object.");
  }
}

void keyPressed(){
  if(PLOTTING_ENABLED) myPort.stop();
  exit();
}
