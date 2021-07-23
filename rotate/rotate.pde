void setup(){
  size(500, 500);
  background(255);
  rectMode(CENTER);
}

void draw(){
  pushMatrix();
  translate(width/2,height/2);
  rotate(QUARTER_PI);
  rect(0, 0, 200, 200);
  println("x:" + screenX(0,0) + " y:" + screenY(0,0));
  popMatrix();
  println("x:" + screenX(0,0) + " y:" + screenY(0,0));
}
