class Pantalla {
  String nombre;
  PImage fondo;
  PImage fondoEsc;
  Boton[] botones;
  int[] destinos;
  int i;

  Pantalla(String nombre, PImage fondo, int cb) {
    this.nombre = nombre;
    this.fondo = fondo;
    float esc = min((float) width / fondo.width, (float) height / fondo.height);
    fondoEsc = fondo.get();
    fondoEsc.resize(round(fondo.width * esc), round(fondo.height * esc));
    botones = new Boton[cb];
    destinos = new int[cb];
  }

  void Ponerboton(int i, Boton boton, int destino) {
    botones[i] = boton;
    destinos[i] = destino;
  }

  void draw() {
    boolean encima = false;
    for (Boton b : botones) {
      b.actualizar(mouseX, mouseY);
    }
    for (Boton b : botones) {
      b.dibujar();
      if (b.estaEncima(mouseX, mouseY)) encima = true;
    }
    cursor(encima ? HAND : ARROW);
  }

  int click() {

    for (int i = 0; i < botones.length; i++) {
      if (botones[i].estaEncima(mouseX, mouseY)) {
        botones[i].presionar();
        return destinos[i];
      }
    }
    return -1;
  }
}
