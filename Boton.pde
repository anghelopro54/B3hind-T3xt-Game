class Boton {
  String nombre;
  // Rectangulo en coordenadas de la imagen original
  float ix, iy, iw, ih;
  PImage imgBoton;

  float escala = 1.0;     // escala actual (animada)
  float objetivo = 1.0;   // escala a la que quiere llegar
  float brillo = 0;       // 0..1 resplandor al pasar el cursor

  Boton(String nombre, float ix, float iy, float iw, float ih, PImage fondo) {
    this.nombre = nombre;
    this.ix = ix;
    this.iy = iy;
    this.iw = iw;
    this.ih = ih;
    // Recorte del boton tomado de la imagen original (sin deformar)
    this.imgBoton = fondo.get(int(ix), int(iy), int(iw), int(ih));
  }

  // --- Conversion imagen -> pantalla ---
  float pantallaX() { return offsetX + ix * escalaFondo; }
  float pantallaY() { return offsetY + iy * escalaFondo; }
  float pantallaW() { return iw * escalaFondo; }
  float pantallaH() { return ih * escalaFondo; }

  boolean estaEncima(float mx, float my) {
    return mx > pantallaX() && mx < pantallaX() + pantallaW()
        && my > pantallaY() && my < pantallaY() + pantallaH();
  }

  void presionar() {
    escala = 0.93;   // hundimiento al hacer click
  }

  void actualizar(float mx, float my) {
    boolean encima = estaEncima(mx, my);
    objetivo = encima ? 1.10 : 1.0;
    escala = lerp(escala, objetivo, 0.18);
    brillo = lerp(brillo, encima ? 1 : 0, 0.18);
  }

  void dibujar() {
    if (escala < 1.002 && brillo < 0.01) return;  // en reposo se ve el fondo tal cual

    float w = pantallaW();
    float h = pantallaH();

    pushMatrix();
    translate(pantallaX() + w / 2, pantallaY() + h / 2);
    scale(escala);

    // Resplandor suave detras
    rectMode(CENTER);
    noStroke();
    fill(255, 255, 255, 90 * brillo);
    rect(0, 0, w + 14, h + 14, 14);

    // Imagen del boton
    imageMode(CENTER);
    image(imgBoton, 0, 0, w, h);

    // Brillo encima
    fill(255, 255, 255, 40 * brillo);
    rect(0, 0, w, h, 6);
    popMatrix();

    // Restaurar modos para no afectar el resto del dibujo
    rectMode(CORNER);
    imageMode(CORNER);
  }
}
