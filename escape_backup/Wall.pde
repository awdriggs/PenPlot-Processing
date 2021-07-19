class Wall{
  //start of the line
  PVector position;

  //end of the line
  //thickness of vitrual line
  float w;
  float h;

  Wall(float _x, float _y, float _w, float _h){
    position = new PVector(_x, _y);
    w = _w;
    h = _h;
  }

  void render(){
    rect(position.x, position.y, w, h);
  }

  boolean contains(PVector spot) {
    if (spot.x > position.x && spot.x < position.x + w && spot.y > position.y && spot.y < position.y + h) {
      return true;
    } else {
      return false;
    }
  }
}
