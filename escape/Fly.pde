class Fly {
  //Define Variables
  PVector loc;
  PVector vel = new PVector(random(-2, 2), random(-2, 2));
  PVector startLoc;
  PVector ploc = new PVector();
  //PVector right= new PVector();
  //PVector left=new PVector();
  PVector check = new PVector();
  PVector angle = new PVector(random(0, TWO_PI), random(0, TWO_PI));
  color c = color(random(50, 200));
  color g = color(0, 255, 0);
  color r = color(255, 0, 0);
  color w = color(255);

  int offset;

  //random(0, TWO_PI);
  //angle.y = random(0, TWO_PI); //1.0; //??
  float stepSize = 0.8; //change to effect the step size
  float speed = 5; //ellipse
  float baseAngle = 0;
  float dev;
  float lean = 0.95;
  float devAllow = 2.0; //amount of "jitter" before easing
  float push = 0.1;
  float angleChange = 0.1;
  int dia = 10;

  float threshold = 50.0;


  //Define Constructor
  Fly(PVector l, int d) {
    startLoc = l.get();
    loc = l.get();
    dia = d;
  }

  void go() {
    walk();
    /* checkBright(); */
    borders();
    //cell();
    render();
    locations.add(new PVector (loc.x, loc.y));
  }

  //random walk
  void walk() {
    //float lean = map(mouseX, 0, width, 0.9, 1.1);
    angle.x += random(-stepSize, stepSize);
    angle.y += random(-stepSize, stepSize);


    //angle += random(-stepSize, stepSize);
    //dev = angle - baseAngle;

    if (dev > devAllow || dev < -devAllow) {
      //angle *= lean;
      //println("dev");
    }

    //check for a collision with the new x value
    //if true, refeect x angle, update the x value
    //check.x += sin(angle.x) * speed;

    //check for collision with the new y value
    //if true, reflect y angle, update the y value
    /* if(cell()){ */
    /*   println("horizontal hit"); */
    /*   angle.x *= -1; */
    /*   check.x += sin(angle.x) * speed; */
    /* } */

    /* loc.x += sin(angle.x) * speed; */

    /* check.y += sin(angle.y) * speed; */

    /* if(cell()){ */
    /*   println("vertical hit"); */
    /*   angle.y *= -1; */
    /*   loc.y += sin(angle.x) * speed; */
    /* } */
    cell(); 
    loc.x += sin(angle.x) * speed;
    loc.y += sin(angle.y) * speed;
    check.x = loc.x+sin(angle.x)*dia/2+1;
    check.y = loc.y+sin(angle.y)*dia/2+1;
  }

  void render() {
    fill(c);
    noStroke();
    ellipse(loc.x, loc.y, dia, dia);
    //point(loc.x, loc.y);
    if (debug == true) {
      stroke(255, 0, 0);
      ellipse(check.x, check.y, 5, 5);
    }
  }

  void borders() {
    if (check.x>width-2 || check.x<0+2 ) {
      //println("x hit" + " angle: " + angle);
      angle.x *= -1;

    }
    else if (check.y>height-2 || check.y<0+2) {
      //println("y hit" + " angle: " + angle);
      angle.y *= -1;
    }
  }

  void cell() {

    for (Wall wall : walls) {
      if(wall.contains(new PVector(loc.x + sin(angle.x)*speed, loc.y))){
        println("horziontal hit");
        /* println(PVector.angleBetween(loc, check)); */
        println(angle);
        angle.x *= -1;
        break;
      }
    }

    for (Wall wall : walls) {
      if(wall.contains(new PVector(loc.x, loc.y + sin(angle.y)*speed))){
        println("vertical hit");
        /* println(PVector.angleBetween(loc, check)); */
        println(angle);
        angle.y *= -1;
        break;
      }
    }
  }



}
