import processing.serial.*; //import the serial class library

Serial myPort;    // Create object from Serial class
Plotter plotter;  // Create a plotter object

int val;          // Data received from the serial port, needed?

//Enable plotting? //toggle for debug
final boolean PLOTTING_ENABLED = true;

String label = "TEST"; //Label, not using right now

int xMin, yMin, xMax, yMax; //Plotter dimensions, set in "printer units"
// these values are assigned in the with the setPaper function

int count = 0; //count the number of rounds that it takes

//setup for points
// init goal
// init points array
// init mutation rate
// init size of point
PVector goal;
Point[] population = new Point[25];
float mutationRate = 0.1;
int pointSize = 10;
int threshold = 5; //used to know when to stop the program

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

//Let's set this up
void setup() {
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

  //some standard processing stuff
  background(255);
  stroke(0);
  smooth();
  //noLoop(); //kill the loop, otherwise your print will never end, but maybe that's what you want ;)

  if(PLOTTING_ENABLED){
    frameRate(0.5); //using this to slow down the commands to the printer
    //pen carousel is fucked!!!
    /* plotter.selectPen(1); //pick a pen */
    delay(5000); //give the printer a chance to warm up
  }

  //init the goal to a random number within the drawing window
  goal = new PVector(random(width), random(height));
  //init the population, loop and create new points
  for(int i = 0; i < population.length; i++){
    population[i] = new Point();
  }

  //speed control?
}

void draw() {
  //draw a cross at the target
  if(count == 0){
    line(goal.x-10, goal.y, goal.x+10, goal.y);
    line(goal.x, goal.y-10, goal.x, goal.y+10);

    if(PLOTTING_ENABLED){
      plotter.drawLine(goal.x-10, goal.y, goal.x+10, goal.y);
      plotter.drawLine(goal.x, goal.y-10, goal.x, goal.y+10);
      delay(100);
    }
  }


  //do some calc to see if should continue, like avg distance or something
  float distanceSum = 0;
  for(int i = 0; i < population.length; i++){
    distanceSum += PVector.dist(population[i].location, goal);
  }

  float distanceAvg = distanceSum / population.length;
  println(distanceAvg);


  //if continue
  if(distanceAvg > threshold){
    //draw points, delay if printing
    //caclulate fitness
    for(int i = 0; i < population.length; i++){
      population[i].display(pointSize);
      population[i].calculateFitness(); //fitness score needed for selection

      if(PLOTTING_ENABLED){
        plotter.drawCircle(population[i].location.x, population[i].location.y, pointSize, 10); 
      }
    }

    //select mating pool
    // create the mating pool
    ArrayList<Point> matingPool = new ArrayList<Point>();

    for(int i = 0; i < population.length; i++){
      for(int j = 0; j < population[i].fitness * 100; j++){
        //add to the mating pool
        matingPool.add(population[i]);
      }
    }

    //REPRODUCE
    for(int i = 0; i < population.length; i++){
      if(population[i].distance > 5){
        int a = int(random(matingPool.size()));
        int b = int(random(matingPool.size()));

        Point parentA = matingPool.get(a);
        Point parentB = matingPool.get(b);

        Point child = parentA.crossover(parentB);

        //mutate
        child.mutate(mutationRate);
        population[i] = child;
      }
    }

    //delay if printing
    //loop

  } else {
    if(PLOTTING_ENABLED){
      plotter.endPrint();
      myPort.stop();
    }
    println("close enough!");
    exit();
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

