import processing.serial.*; //import the serial class library

Serial myPort;    // Create object from Serial class
Plotter plotter;  // Create a plotter object
int val;          // Data received from the serial port, needed?

//Enable plotting? //toggle for debug
final boolean PLOTTING_ENABLED = true;

String label = "TEST"; //Label, not using right now


int xMin, yMin, xMax, yMax; //Plotter dimensions, set in "printer units"

// the line segments
int numSegments = 10;
float margin, segmentLength;
PVector[] vertices = new PVector[numSegments];

//the repeat
int repeat, offset, count;

void settings() {
  // Set the paper size first, this allows the preview window to be in proportion
  // "A" = letter size, "B" = tabloid size, "A4" = metric A4, "A3" = metric A3
  setPaper("A");

  println("print dimensions", xMin, yMin, xMax, yMax); //

  // Calculate the screen dimension
  int screenWidth = (xMax - xMin)/20;
  int screenHeight = (yMax - yMin)/20;

  //set the canvas size depending on the paper size that will be used... 
  size(screenWidth, screenHeight);
  println("screen dimensions", width, height);
}

//Let's set this up
void setup() {

  //select a serial port
  println(Serial.list()); //Print all serial ports to the console

  String portName = Serial.list()[3]; //make sure you pick the right one
  println("Plotting to port: " + portName);

  //open the port
  myPort = new Serial(this, portName, 9600);

  //create a plotter object, let the printer know the papersize
  plotter = new Plotter(myPort, xMin, yMin, xMax, yMax);

  

  //setup everything for drawing!
  //initialize the repeat
  repeat = 100; //draw this many lines
  offset = width/repeat; //calculate how far to move across the page with each path.
  count = 0;

  margin = 0; //for giving some space on the top on bottom of the line segments

  //calculate the length of the segment
  //leave some margin on either side, divide into segments
  //since the first and last segments are 'anchors', use one less than the number of segments
  segmentLength = (height - 2 * margin) / (numSegments-1);

  //initialize the vertices that will make the line
  //the x the offset to start
  //the y is set to distribute the vertices equal in the available space
  //the z index is being used as a threshold for the random change, 5 is neutral
  for (int i = 0; i < vertices.length; i++) {
    vertices[i] = new PVector(offset/2, segmentLength * i + margin, 5); 
    //println(i, vertices[i]);
  }

  //some standard processing stuff
  background(255); 
  frameRate(0.5); //using this to slow down the commands to the printer
  smooth();
  /* plotter.selectPen(1); //pick a pen */
  delay(5000); //give the printer a chance to warm up
  //noLoop(); //kill the loop, otherwise your print will never end, but maybe that's what you want ;)
}

void draw() {
  //if count is less then repeat
  if (count < repeat) {
    //draw the lines
    //update the lines
    //update the count
    drawLines(); //for screen preview
    plotter.drawLines(vertices); //for plotting
    
    updateVertices(2);
    println(count, repeat);
    
    count++;
    
    
  } else {
    //else, printing is over
    //println("done priting");
    //put the pen back  
    /* plotter.selectPen(0); //put the pen back */
    
    //stop the serial port for clean exit
    myPort.stop();
    exit(); //exit the program automatically
  }
  
  delay(1000);
  //delay(1000); //
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

void updateVertices(int jump) {
  //loop through the vertices array
  //the x value of each will either increase, decrease, or stagnate depending on a random behavior 
  for (int i = 0; i < vertices.length; i++) {

    vertices[i].x += offset; //first, update by an offset so the lines fill the page

    // variable probability, use the pvector z component as a threshold
    //create a 'tendency' towards straightness
    // all z's are 5 to start

    // generate a random number between 0 and 10
    int randNum = floor(random(1)*11);

    // if greate than threshold, add to the y value 
    // raise the threshold by 1
    //if less than threshold, sub from the value by jump move down, 
    // lower theshold by -1
    //if at threshold stay
    if (randNum > vertices[i].z) {
      vertices[i].x += jump;
      vertices[i].z += 1; //increase the threshold
    } else if (randNum < vertices[i].z) {
      vertices[i].x -= jump;
      vertices[i].z -= 1; //decrease the threshold
    }
  }
}

//for screen preview
void drawLines() {
  //loop through the vertices, don't run on the last vertex
  //draw a line from current point to next point
  for (int i = 0; i < vertices.length - 1; i++) {
    line(vertices[i].x, vertices[i].y, vertices[i+1].x, vertices[i+1].y);
  }
}
