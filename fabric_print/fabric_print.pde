//sketch vairables
PVector grid[][];
int numCols;
int numRows;
float hMargin;
float vMargin;

//plotter setup
import processing.serial.*; //import the serial class library
Serial myPort;    // Create object from Serial class
Plotter plotter;  // Create a plotter object

final boolean PLOTTING_ENABLED = true;

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

  hMargin = width/2 - 125;
  vMargin = height/2 - 250;
}

void setup(){
  parse(); //read in a file called points.txt, stores data in the grid array
  noLoop(); //no reason to draw twice!

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
}

void draw(){
  preview();
  //loop through grid, draw the rows, then draw the cols
  println("cols", numCols, "rows", numRows);
   
  if(PLOTTING_ENABLED){
    plotter.sendTo(grid[0][0].x, grid[0][0].y, false);
    //draw a line connecting the points in each col
    for(int i = 0; i < numCols; i++){
      //draw lines between each point in the pvector
      plotter.drawLines(grid[i]);
      delay(3000);
    }
    plotter.sendTo(grid[0][0].x, grid[0][0].y, false);
    delay(5000);
    //draw a line connecting the points in each row
    for(int j = 0; j < numRows; j++){
      PVector column[] = new PVector[numCols];

      for(int i = 0; i < numCols; i++){
        column[i] = grid[i][j] ;
      }
      println(column.length);
      println(column);
      plotter.drawLines(column);
      delay(5000);
    }
  } //end of plotting enabled
}

//read in a text file
//header line contians the size of a 2d array
//the remaining lines give the 2d coords, followed by x y data pair
void parse(){
  BufferedReader reader = createReader("points.txt");
  String line = null;

  try {
    //read first line
    String size[] = split(reader.readLine(), ",");

    //init grid with the sizes, needs to be cast to an int
    numCols = int(size[0]);
    numRows = int(size[1]);

    grid = new PVector[numCols][numRows];

    //loop through the rest of the file
    while ((line = reader.readLine()) != null) {
      String[] parts = split(line, ",");
      //at the given index, write the location of this point
      grid[int(parts[0])][int(parts[1])] = new PVector(float(parts[2])+hMargin, float(parts[3])+vMargin);
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}

void preview(){

  for(int i = 0; i < numCols; i++){
    //for screen drawing
    for(int j = 0; j < numRows - 1; j++){
      line(grid[i][j].x, grid[i][j].y, grid[i][j+1].x, grid[i][j+1].y);
    }
  }
  //draw a line connecting the points in each row
  for(int i = 0; i < numCols - 1; i++){
    for(int j = 0; j < numRows; j++){
      line(grid[i][j].x, grid[i][j].y, grid[i+1][j].x, grid[i+1][j].y);
    }
  }
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

