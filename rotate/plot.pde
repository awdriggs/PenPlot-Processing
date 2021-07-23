import processing.serial.*;

Serial myPort;    // Create object from Serial class
Plotter plotter;  // Create a plotter object
int val;          // Data received from the serial port, needed?

//Enable plotting? //toggle for debug
final boolean PLOTTING_ENABLED = false;

//Label
String label = "TEST";

//Plotter dimensions
int xMin, yMin, xMax, yMax;

void settings(){
 // Set the paper size first, this allows the preview window to be in proportion
 // "A" = letter size, "B" = tabloid size, "A4" = metric A4, "A3" = metric A3
 setPaper("A");
 
 println("print dimensions", xMin, yMin, xMax, yMax);
 
 // Calculate the 
 int screenWidth = (xMax - xMin)/20;
 int screenHeight = (yMax - yMin)/20;
 
 //set the canvas size depending on the paper size that will be used... 
 size(screenWidth, screenHeight);
 println("screen dimensions", width, height);
}

//Let's set this up
void setup(){
 
  //select a serial port
  println(Serial.list()); //Print all serial ports to the console
  
  String portName = Serial.list()[3]; //make sure you pick the right one
  println("Plotting to port: " + portName);
  
  //open the port
  myPort = new Serial(this, portName, 9600);
   

  //create a plotter object, let the printer know the papersize
  plotter = new Plotter(myPort, xMin, yMin, xMax, yMax);
  
  noLoop(); //kill the loop, otherwise your print will never end, but maybe that's what you want ;)
}

void draw(){
  plotter.selectPen(1); //pick a pen

  //drawing here
  pushMatrix();
  translate(width/2,height/2);
  rotate(QUARTER_PI);
  rect(0, 0, 200, 200);
  println("x:" + screenX(0,0) + " y:" + screenY(0,0));
  
  popMatrix();
  //end the printing
  myPort.stop();
  exit();
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
