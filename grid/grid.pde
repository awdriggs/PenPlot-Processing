float offset = 0;
float x = 0;
float y = 0;

void setup(){
  size(800, 800);
  background(255);
}

void draw(){
  /*
  //background(255); 
  if(x < width){
    line(x - offset,0, x-offset, height);
    x+=frameCount/10;
  }
  if(y < height){
    line(0,y -offset , width, y - offset);
    y+=frameCount/10;
  }
 */ 
  if(y < height){
    line(0,y -offset , x, y - offset);
    y+=frameCount;
  }

  if(x < width){
    line(x- offset,0, x-offset, y);
    x+=frameCount;
  }
  
  
}
