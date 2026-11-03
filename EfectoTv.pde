// Efecto de television antigua: lineas horizontales oscuras que bajan despacio sobre toda la pantalla.
class EfectoTv {
  int esp = 8;       // separacion entre lineas (pixeles)
  int grosor = 3;    // grosor de cada linea

  // Se llama una vez por cuadro desde draw() de B3hind_T3xt.pde
  void dibujar() {
    noStroke();
    fill(0, 60);                                  // negro semitransparente
    int desp = int(frameCount * 0.3) % esp;       // desplazamiento: hace que las lineas "bajen"
    for (int y = desp - esp; y < height; y += esp) {
      rect(0, y, width, grosor);
    }
  }
}
