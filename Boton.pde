// =====================================================================================
// Boton: boton del menu hecho a partir de un recorte de la imagen de fondo.
// Crece y brilla al pasar el mouse, y "se hunde" al hacer clic.
// Sus coordenadas estan en pixeles de la imagen original; escalaFondo/offsetX/offsetY las
// convierten a la ventana (asi funciona en cualquier resolucion).
// =====================================================================================
class Boton {
  String nombre;
  float ix, iy, iw, ih;   // rectangulo en coordenadas de la imagen original
  PImage imgBoton;        // recorte del fondo que representa el boton

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

  // true si el punto (mx, my) de la ventana esta dentro del boton
  boolean estaEncima(float mx, float my) {
    return mx > pantallaX() && mx < pantallaX() + pantallaW()
        && my > pantallaY() && my < pantallaY() + pantallaH();
  }

  // Efecto de clic: el boton se encoge de golpe y luego vuelve a crecer solo
  void presionar() {
    escala = 0.93;   // hundimiento al hacer click
  }

  // Acerca suavemente la escala y el brillo a su objetivo (lerp = avanzar un 18% del camino cada cuadro)
  void actualizar(float mx, float my) {
    boolean encima = estaEncima(mx, my);
    objetivo = encima ? 1.10 : 1.0;
    escala = lerp(escala, objetivo, 0.18);
    brillo = lerp(brillo, encima ? 1 : 0, 0.18);
  }

  // Dibuja el boton animado encima del fondo (solo cuando esta crecido o brillando)
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
