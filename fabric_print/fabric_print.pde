PVector grid[][];

void setup(){
  parse();
}

void parse(){
  BufferedReader reader = createReader("points.txt");
  String line = null;

  try {
    String size[] = split(reader.readLine(), ",");
     
/* int i = Integer.parseInt(myString); */
    grid = new PVector[int(size[0])][int(size[1])];
    println(grid.length); 
    while ((line = reader.readLine()) != null) {
      String[] parts = split(line, ","); 
      /* println("index", parts[0], parts[1]); */
      grid[int(parts[0])][int(parts[1])] = new PVector(float(parts[2]), float(parts[3]));
       
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }

  println(grid[3][2]);
}
