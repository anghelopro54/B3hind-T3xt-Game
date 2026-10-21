// BotonRetro - hereda de Boton (misma animacion de hover / click y misma conversion de
// coordenadas), pero se dibuja a si mismo en vez de recortarse del fondo.
// Boton original: el dibujo del boton ya viene pintado en el arte del menu.
// Pantallas nuevas (juego, creditos): no hay arte, asi que el boton se dibuja por codigo.

class BotonRetro extends Boton {
  String tecla;                 // etiqueta de teclado ("B", "R", "ESC"...) o "" si no lleva
  int base    = #4B5FA8;
  int resalte = #7C93E8;
  int borde   = #C9D6FF;

  BotonRetro(String nombre, String tecla, float ix, float iy, float iw, float ih, PImage fondo) {
    super(nombre, ix, iy, iw, ih, fondo);
    this.tecla = tecla;
  }

  void dibujar() {
    float w = pantallaW();
    float h = pantallaH();
    boolean horizontal = h < w * 0.5;     // botones anchos y bajos: tecla a la izquierda

    pushMatrix();
    translate(pantallaX() + w / 2, pantallaY() + h / 2);
    scale(escala);
    rectMode(CENTER);

    // Sombra y resplandor
    noStroke();
    fill(0, 120);
    rect(ss(6), ss(8), w, h, ss(14));
    if (brillo > 0.01) {
      fill(255, 255, 255, 70 * brillo);
      rect(0, 0, w + ss(18), h + ss(18), ss(20));
    }

    // Cuerpo
    stroke(borde);
    strokeWeight(max(1.5, ss(4)));
    fill(lerpColor(base, resalte, brillo));
    rect(0, 0, w, h, ss(14));

    // Franja de luz superior
    noStroke();
    fill(255, 38);
    rect(0, -h * 0.26, w - ss(22), h * 0.34, ss(10));

    boolean conTecla = tecla != null && tecla.length() > 0;
    if (!conTecla) {
      float t = tamQueCabe(nombre, w * 0.86, h * 0.34);
      textoPx(nombre, 0, 0, t, color(255), CENTER, CENTER);
    } else if (!horizontal) {
      float k = min(w * 0.34, h * 0.40);
      dibujarTecla(0, -h * 0.20, k);
      float t = tamQueCabe(nombre, w * 0.88, h * 0.19);
      textoPx(nombre, 0, h * 0.27, t, color(255), CENTER, CENTER);
    } else {
      float k = h * 0.60;
      float kx = -w / 2 + k * 0.95;
      dibujarTecla(kx, 0, k);
      float zona = w - k * 1.9;
      float t = tamQueCabe(nombre, zona * 0.9, h * 0.38);
      textoPx(nombre, kx + k * 0.75 + zona / 2, 0, t, color(255), CENTER, CENTER);
    }
    popMatrix();

    rectMode(CORNER);
    imageMode(CORNER);
  }

  // Tecla de teclado: cuadrito claro con la letra
  void dibujarTecla(float cx, float cy, float k) {
    rectMode(CENTER);
    stroke(#7F8FC8);
    strokeWeight(max(1, ss(3)));
    fill(#DDE6FF);
    rect(cx, cy, k * (tecla.length() > 1 ? 1.5 : 1), k, ss(8));
    noStroke();
    fill(255, 120);
    rect(cx, cy - k * 0.28, k * (tecla.length() > 1 ? 1.3 : 0.8), k * 0.18, ss(4));
    float t = tamQueCabe(tecla, k * (tecla.length() > 1 ? 1.3 : 0.8), k * 0.62);
    textFont(fuentePixel);
    textAlign(CENTER, CENTER);
    textSize(max(1, t));
    fill(#26305E);
    text(tecla, cx, cy + k * 0.04);
  }
}
