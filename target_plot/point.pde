class Point {
  /* PVector target; */
  PVector location;
  float fitness = 0;
  float distance;
  //constructor, set a random location
  /* Point(PVector _target){ */
  Point(){
    /* target = _target; */

    //set a random point to start
    location = new PVector(random(width), random(height));
  }

  // Constructor, set to a given location
  Point(PVector _location) {
    // We could make a copy if necessary
    // genes = (PVector []) newgenes.clone();
    location = _location;
  }

  //calculate fitness
  void calculateFitness(){
    //find the distance
    distance = location.dist(goal);
    //normalize the distance
    float distanceNormalized = norm(distance, 0, width);
    /* println(distance); */

    float inverse = 1 - distanceNormalized;
    //do 1 minus the normalized distance

    fitness = pow(2,inverse); //hug advantage! maybe make it not exponential?
    /* fitness = inverse; //no advantage! */
    /* println("i: ", inverse); */
    /* println("f: ", fitness); */

    //add something here, if it is within a range of the target
    //multiple fitness by 100
    if(distance < 20) fitness *= 100;
  }

  //crossover
  Point crossover(Point partner){
    PVector childLocation = new PVector();

    //flip a coin to see who's x value to take
    float coin = random(1);
    if(coin >= 0.5){
      childLocation.x = location.x;
    } else {
      childLocation.x = partner.location.x;
    }

    //flip a coint to see who's y value to take
    coin = random(1);
    if(coin >= 0.5){
      childLocation.y = location.y;
    } else {
      childLocation.y = partner.location.y;
    }

    //return a new pvect with the new location
    return new Point(childLocation);
  }

  //mutate
  void mutate(float _mRate){
    int stepSize = 50;
    if(random(1) < _mRate){
      /* location.x = random(width); */
      //don't do a totally random locate, just change by a little
      if(random(1) > 0.5){
        location.x += random(stepSize);
        location.y += random(stepSize);
      } else {
        location.x -= random(stepSize);
        location.y -= random(stepSize);
      }
    }

    /* if(random(1) < _mRate){ */
    /*   /1* location.y = random(height); *1/ */
    /*   if(random(1) > 0.5){ */
    /*     location.y += random(stepSize); */
    /*   } else { */
    /*     location.y -= random(stepSize); */
    /*   } */
    /* } */
  }

  //display
  void display(int _size){
    ellipse(location.x, location.y, _size, _size);
  }

}
