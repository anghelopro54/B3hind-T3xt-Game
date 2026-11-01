class PantallaConfiguracion extends Pantalla {
  PantallaConfiguracion() {
    super("CONFIGURACION", crearFondoConfiguracion(), 1);
    Ponerboton(0, new Boton("Volver", 1700, 43, 200, 65, fondo), 0);
  }

  // ---- Barras de volumen (coordenadas del lienzo 1920x1080) ----
  float barraX = 560, barraW = 800, barraH = 16;
  float musicaY = 430, efectosY = 620;
  int arrastrando = 0;                 // 0 = ninguna, 1 = musica, 2 = efectos

  float mouseVX() { return (mouseX - offsetX) / escalaFondo; }
  float mouseVY() { return (mouseY - offsetY) / escalaFondo; }

  boolean encimaBarra(float y) {
    float mx = mouseVX(), my = mouseVY();
    return mx >= barraX - 20 && mx <= barraX + barraW + 20 && abs(my - y) <= 28;
  }

  void reiniciar() {
    arrastrando = 0;
  }

  int click() {
    if (encimaBarra(musicaY)) { arrastrando = 1; return -1; }
    if (encimaBarra(efectosY)) { arrastrando = 2; return -1; }
    int d = super.click();
    if (d == 0 && configVolverA > 0) {
      d = configVolverA;
      configVolverA = 0;
    }
    return d;
  }

  void draw() {
    // mientras se mantiene el boton pulsado sobre una barra, se actualiza el volumen
    if (arrastrando != 0) {
      if (mousePressed) {
        float v = constrain((mouseVX() - barraX) / barraW, 0, 1);   // 0 a 1 (fraccion de la barra)
        if (arrastrando == 1) {
          musica.volumen = v * musica.MAX_MUSICA;
          if (musica.sonando != null) musica.sonando.amp(musica.volumen);
        } else {
          musica.volumenEfectos = v * musica.MAX_EFECTOS;
        }
      } else {
        if (arrastrando == 2) musica.efecto("botonmenu.mp3");   // sonido de prueba al soltar
        arrastrando = 0;
      }
    }

    super.draw();

    pushMatrix();
    translate(offsetX, offsetY);
    scale(escalaFondo);
    dibujarBarra("Musica", musicaY, musica.volumen / musica.MAX_MUSICA, arrastrando == 1 || encimaBarra(musicaY));
    dibujarBarra("Botones", efectosY, musica.volumenEfectos / musica.MAX_EFECTOS, arrastrando == 2 || encimaBarra(efectosY));
    popMatrix();
  }

  void dibujarBarra(String titulo, float y, float valor, boolean activa) {
    textFont(fuente);
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(36);
    text(titulo, barraX, y - 50);
    textAlign(RIGHT, CENTER);
    text(round(valor * 100) + "%", barraX + barraW, y - 50);

    rectMode(CORNER);
    stroke(20, 20, 60);
    strokeWeight(4);
    fill(40, 44, 60);
    rect(barraX, y - barraH / 2, barraW, barraH, 8);
    noStroke();
    fill(150, 179, 230);
    rect(barraX, y - barraH / 2, barraW * valor, barraH, 8);

    stroke(20, 20, 60);
    strokeWeight(4);
    fill(activa ? color(255, 255, 255) : color(200, 220, 255));
    ellipse(barraX + barraW * valor, y, 36, 36);
    noStroke();
  }
}

PGraphics crearFondoConfiguracion() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  ventanaxp(pg, "Configuracion.exe", 440, true);
  pg.endDraw();

  return pg;
}
