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

  void reiniciar(){ }
}

// version corta: la que ya usas (fondo de color plano)
void ventanaxp(PGraphics pg, String titulo, float xTitulo, boolean volver){
    ventanaxp(pg, titulo, xTitulo, volver, null);
}

// version con imagen de fondo (si fondoImg es null, usa el color plano)
void ventanaxp(PGraphics pg, String titulo, float xTitulo, boolean volver, PImage fondoImg){
    pg.textFont(fuente);
    if (fondoImg != null) imagenCover(pg, fondoImg);
    else pg.background(40, 30, 70);

    // tamano de la ventana y cuanto se encogio respecto a la original (1350 x 950)
    float vw = 1100, vh = 800;
    float dx = (1350 - vw) / 2;     // 125
    float dy = (950 - vh) / 2;      // 75

    if (volver) {
      pg.rectMode(CORNER);
      pg.fill(150, 179, 230);
      pg.stroke(20, 20, 60);
      pg.strokeWeight(6);
      pg.rect(1700, 43, 200, 65, 20);
      pg.fill(20, 20, 60);
      pg.textAlign(CENTER, CENTER);
      pg.textSize(37);
      pg.text("Volver", 1801, 75);
    }

    pg.rectMode(CENTER);
    pg.fill(94, 104, 115);
    pg.stroke(140, 70, 200);                 // borde morado (cambia aqui el color)
    pg.strokeWeight(40);
    pg.rect(pg.width / 2, pg.height / 2, vw, vh, 10);

    // botones de la barra de titulo (siguen la esquina superior derecha de la ventana)
    pg.stroke(255);
    pg.strokeWeight(2);
    pg.fill(70, 142, 224);
    pg.rect(1490 - dx, 66 + dy, 40, 30, 10);
    pg.rect(1540 - dx, 66 + dy, 40, 30, 10);
    pg.fill(250, 12, 12);
    pg.rect(1590 - dx, 66 + dy, 40, 30, 10);

    // titulo (sigue la esquina superior izquierda)
    pg.fill(255);
    pg.textAlign(CENTER, CENTER);
    pg.textSize(30);
    pg.text(titulo, xTitulo + dx, 67 + dy);

    pg.rectMode(CORNER);
}

  PImage escalarPantalla(PImage img){
    float esc = min((float) width / img.width, (float) height / img.height);
    PImage copia = img.get();
    copia.resize(round(img.width * esc), round(img.height * esc));
    
    return copia;

  }
