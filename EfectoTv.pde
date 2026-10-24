class EfectoTv {
  int esp = 8; 
  int grosor = 3;
  

  void dibujar() {
    noStroke();
    fill(0, 60);
    int desp = int(frameCount * 0.3) % esp;
    for(int y = desp - esp; y < height; y += esp){
      rect(0, y, width, grosor);
    }
  }
}
