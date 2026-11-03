// =====================================================================================
// Configuracion: dos barras de volumen (musica y botones) que se arrastran con el mouse.
// Si se abrio desde la pausa de un modo, "Volver" regresa a la partida (configVolverA).
// =====================================================================================
class PantallaConfiguracion extends Pantalla {
  PantallaConfiguracion() {
    super("CONFIGURACION", crearFondoConfiguracion(), 1);
    Ponerboton(0, new Boton("Volver", 1700, 43, 200, 65, fondo), P_MENU);
  }

  // ---- Barras de volumen (coordenadas del lienzo 1920x1080) ----
  float barraX = 560, barraW = 800, barraH = 16;
  float musicaY = 430, efectosY = 620;
  int arrastrando = 0;                 // 0 = ninguna, 1 = musica, 2 = efectos

  // Posicion del mouse convertida al lienzo 1920x1080
  float mouseVX() { return (mouseX - offsetX) / escalaFondo; }
  float mouseVY() { return (mouseY - offsetY) / escalaFondo; }

  // true si el mouse esta sobre la barra que esta en la altura y
  boolean encimaBarra(float y) {
    float mx = mouseVX(), my = mouseVY();
    return mx >= barraX - 20 && mx <= barraX + barraW + 20 && abs(my - y) <= 28;
  }

  // Al entrar, ninguna barra esta siendo arrastrada
  void reiniciar() {
    arrastrando = 0;
  }

  // Clic: empieza a arrastrar una barra, o pulsa Volver
  int click() {
    if (encimaBarra(musicaY)) { arrastrando = 1; return -1; }
    if (encimaBarra(efectosY)) { arrastrando = 2; return -1; }
    int d = super.click();
    if (d == P_MENU && configVolverA > 0) {
      d = configVolverA;
      configVolverA = 0;
    }
    return d;
  }

  // Si se mantiene el clic sobre una barra, actualiza el volumen; despues dibuja el boton Volver y las barras
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

  // Dibuja una barra: titulo, porcentaje, riel, parte llena y perilla. valor va de 0 a 1.
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

// Fondo de la pantalla: una ventana XP vacia (las barras se dibujan encima en draw)
PGraphics crearFondoConfiguracion() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  ventanaxp(pg, "Configuracion.exe", 440, true);
  pg.endDraw();

  return pg;
}
