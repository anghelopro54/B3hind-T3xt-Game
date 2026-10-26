// Menu de pausa del Modo 1: ventana con 3 botones (Reanudar, Configuracion, Salir al menu).
// Todo se define en coordenadas del canvas 1920x1080, igual que el resto de pantallas.
class MenuPausa {
  String[] etiquetas = {"Reanudar", "Configuración", "Salir al menú"};

  // ventana
  float vx = 610, vy = 250, vw = 700, vh = 580;
  // botones
  float bx = 760, bw = 400, bh = 80, by0 = 380, hueco = 30;

  float[] brillo = new float[3];       // 0..1, animacion al pasar el mouse

  float botonY(int i) { return by0 + i * (bh + hueco); }

  // Boton (0, 1 o 2) bajo el mouse, o -1
  int encima() {
    for (int i = 0; i < etiquetas.length; i++) {
      float x = offsetX + bx * escalaFondo;
      float y = offsetY + botonY(i) * escalaFondo;
      if (mouseX >= x && mouseX <= x + bw * escalaFondo && mouseY >= y && mouseY <= y + bh * escalaFondo) return i;
    }
    return -1;
  }

  // Devuelve el boton presionado o -1
  int click() {
    return encima();
  }

  void dibujar() {
    float e = escalaFondo;
    int sobre = encima();
    cursor(sobre >= 0 ? HAND : ARROW);

    pushStyle();
    rectMode(CORNER);
    textFont(fuente);

    // oscurece el juego
    noStroke();
    fill(0, 170);
    rect(offsetX, offsetY, 1920 * e, 1080 * e);

    // ventana (mismo estilo que las ventanas XP del menu)
    fill(94, 104, 115);
    stroke(140, 70, 200);
    strokeWeight(14 * e);
    rect(offsetX + vx * e, offsetY + vy * e, vw * e, vh * e, 10 * e);

    // barra de titulo
    noStroke();
    fill(140, 70, 200);
    rect(offsetX + vx * e, offsetY + vy * e, vw * e, 62 * e, 10 * e, 10 * e, 0, 0);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(30 * e);
    text("Pausa.exe", offsetX + (vx + vw / 2) * e, offsetY + (vy + 31) * e);

    // botones
    for (int i = 0; i < etiquetas.length; i++) {
      brillo[i] = lerp(brillo[i], i == sobre ? 1 : 0, 0.2);
      float w = bw * e * (1 + 0.05 * brillo[i]);
      float h = bh * e * (1 + 0.05 * brillo[i]);
      float cx = offsetX + (bx + bw / 2) * e;
      float cy = offsetY + (botonY(i) + bh / 2) * e;

      fill(lerpColor(color(150, 179, 230), color(200, 220, 255), brillo[i]));
      stroke(20, 20, 60);
      strokeWeight(6 * e);
      rect(cx - w / 2, cy - h / 2, w, h, 20 * e);

      fill(20, 20, 60);
      noStroke();
      textSize(34 * e);
      text(etiquetas[i], cx, cy);
    }

    fill(255);
    textSize(22 * e);
    text("ESC para reanudar", offsetX + (vx + vw / 2) * e, offsetY + (vy + vh - 40) * e);
    popStyle();
  }
}
