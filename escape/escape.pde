//escape setup
boolean debug = true;
Fly test;
Wall border; //single wall ;) later make it a box
PVector mouseTest = new PVector(0,0);
ArrayList<Wall> walls = new ArrayList<Wall>();
ArrayList<PVector> locations = new ArrayList<PVector>();

//plotter setup
import processing.serial.*; //import the serial class library
Serial myPort;    // Create object from Serial class
Plotter plotter;  // Create a plotter object

final boolean PLOTTING_ENABLED = false;

int xMin, yMin, xMax, yMax; //Plotter dimensions, set in "printer units"
// these values are assigned in the with the setPaper function

void settings() {
  // Set the paper size first, this allows the preview window to be in proportion
  // "A" = letter size, "B" = tabloid size, "A4" = metric A4, "A3" = metric A3
  setPaper("A");
  println("print dimensions", xMin, yMin, xMax, yMax); //

  // Calculate the screen dimension
  int screenWidth = (xMax - xMin)/10;
  int screenHeight = (yMax - yMin)/10;

  //set the canvas size depending on the paper size that will be used...
  size(screenWidth, screenHeight);
  println("screen dimensions", width, height);
}

void setup(){

  if(PLOTTING_ENABLED){

    //select a serial port
    println(Serial.list()); //Print all serial ports to the console

    String portName = Serial.list()[3]; //make sure you pick the right one
    println("Plotting to port: " + portName);

    //open the port
    myPort = new Serial(this, portName, 9600);


    //create a plotter object, let the printer know the papersize
    plotter = new Plotter(myPort, xMin, yMin, xMax, yMax);
  }

  background(255);
  stroke(0);

  border = new Wall(100, 50, 300, 50);
  //call the build cell with a pvect for the center of the box
  buildCell(new PVector(width/2, height/2));
  test = new Fly(new PVector(width/2 + 150, height/2), 20);

  if(PLOTTING_ENABLED){
    //pen is so fucked!!!!
    /* plotter.selectPen(1); //pick a pen */
    delay(5000); //give the printer a chance to warm up
  }
}

void draw(){
  /* mouseTest.x = mouseX; */
  /* mouseTest.y = mouseY; */

  background(255);
  test.go();
  /* border.render(); */

  //loop through the items in the wall array
  //call render on each item
  // The second is using an enhanced loop:
  for (Wall wall : walls) {
    wall.render();
  }
}

void buildCell(PVector center){
  //center is the center of the box
  //h, the height of the box
  float h = 200;
  //w, the width of the box
  float w = 200;
  //stroke, withe thickness of the walls
  float stroke = 10;

  //vertical offset
  //horizontal offset

  //base
  walls.add(new Wall(center.x - w/2, center.y + h/2, w, stroke));
  //top
  walls.add(new Wall(center.x - w/2, center.y - h/2, w, stroke));
  //left side
  walls.add(new Wall(center.x - w/2, center.y - h/2, stroke, h));
  //right side
  walls.add(new Wall(center.x + w/2 - stroke, center.y - h/2, stroke, h * 0.45));
  walls.add(new Wall(center.x + w/2 - stroke, center.y + h/2 - h * 0.45, stroke, h * 0.45));
}

void mousePressed(){
  noLoop();
  println(locations.size());
  //send the plotter to the first point
  PVector startloc = locations.get(0);
  println(startloc.x, startloc.y);
  if(PLOTTING_ENABLED) plotter.sendTo(startloc.x, startloc.y, true);

  for(int i = 1; i < locations.size(); i++){
    PVector prev = locations.get(i-1);
    println(locations.get(i));
    PVector cur = locations.get(i);
    stroke(0);
    line(prev.x, prev.y, cur.x, cur.y);

    //if drawing, call the drawliens here with the correct verts
    if(PLOTTING_ENABLED) {
      plotter.drawTo(cur.x, cur.y);
      delay(50);
    }
    //if(PLOTTING_ENABLED) plotter.drawLines(vertices); //for plotting
  }

  //end of print, pen up and exit
  if(PLOTTING_ENABLED) plotter.write("PU;");
  //stop the serial port for clean exit
  if(PLOTTING_ENABLED) myPort.stop();
}

// set the global paper size
void setPaper(String size) {
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

