import processing.serial.*;

Serial myPort;    // Create object from Serial class
Plotter plotter;  // Create a plotter object
int val;          // Data received from the serial port, needed?

//Enable plotting? //toggle for debug
final boolean PLOTTING_ENABLED = true;

//Label
String label = "TEST";

//Plotter dimensions
int xMin, yMin, xMax, yMax;

void settings(){
 // Set paper size
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
  
  //Select a serial port
  println(Serial.list()); //Print all serial ports to the console
  String portName = Serial.list()[3]; //make sure you pick the right one
  println("Plotting to port: " + portName);
  
  //Open the port
  myPort = new Serial(this, portName, 9600);

  //Associate with a plotter object
  plotter = new Plotter(myPort, xMin, yMin, xMax, yMax);
  
  
  //Initialize plotter
  /*
  plotter.write("IN;SP1;");
  plotter.write("IP0,0,8236,10776;SC0,100,0,100;");
  */
  
  //Draw a label first (this is pretty cool to watch)
  //float ty = map(80, 0, height, yMin, yMax);
  //plotter.write("PU"+xMax+","+ty+";"); //Position pen
  //plotter.write("SI0.14,0.14;DI0,1;LB" + label + char(3)); //Draw label
  
  //Wait 0.5 second per character while printing label
  
  /*
  if (PLOTTING_ENABLED) {
    delay(label.length() * 500); 
  }
  */
  
  noLoop();
    
}

void draw(){
  plotter.write("PU100,100;");
  //plotter.write("PD500,0,500,500,0,500,0,0;");
  
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
  
  //test it!
  plotter.selectPen(1);
  line(0, height/2, width, height/2);
  plotter.drawLine(0, height/2, width, height/2);
  plotter.drawLine(0, 0, width, 0);
  plotter.drawLine(0, height, width, height);
  
  plotter.selectPen(0);
 
  //end the printing
  myPort.stop();
  //exit();
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

/*************************
  Simple plotter class
*************************/

class Plotter {
//properties
  Serial port;
  int xMin, yMin, xMax, yMax;
  
//constructer
  Plotter(Serial _port, int _xMin, int _yMin, int _xMax, int _yMax){
    port = _port;
    xMin = _xMin;
    yMin = _yMin;
    xMax = _xMax;
    yMax = _yMax;
    
    //init the printer
    write("IN;");
  }
  
//methods
  void write(String hpgl){
    if (PLOTTING_ENABLED){
      port.write(hpgl);
    }
  }
  
  void write(String hpgl, int del){
    if (PLOTTING_ENABLED){
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

  //draw a line
  void drawLine(float _x1, float _y1, float _x2, float _y2) {
    //map input to paper size
    float x1 = map(_x1, 0, width, xMin, xMax);
    float y1 = map(_y1, 0, height, yMin, yMax);
    float x2 = map(_x2, 0, width, xMin, xMax);
    float y2 = map(_y2, 0, height, yMin, yMax);
    
    //pick up pen and go to x1, y1
    write("PU" + x1 + "," + y1 + ";");
    
    //put down pen and go to x2, y2
    write("PD" + x2 + "," + y2 + ";");
    
    //pick up pen
    write("PU;");
  }
  
}