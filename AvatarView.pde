// AvatarView - dibuja al avatar con la expresion que corresponde al estado del juego.
//
// Necesita en data/:  avatar_normal.png, avatar_feliz.png,
//                     avatar_preocupada.png, avatar_sorprendida.png
// (si falta alguno, dibuja una carita de respaldo para que el juego no se caiga)
//
// Reglas de expresion:
//   spam activo        -> SORPRENDIDA (tiene prioridad)
//   bienestar  > 70    -> FELIZ
//   bienestar  < 50    -> PREOCUPADA
//   en medio (50-70)   -> NORMAL

final int AV_NORMAL      = 0;
final int AV_FELIZ       = 1;
final int AV_PREOCUPADA  = 2;
final int AV_SORPRENDIDA = 3;

class AvatarView {
  PImage[] cuerpo = new PImage[4];   // sprite completo
  PImage[] busto  = new PImage[4];   // solo cabeza y torso, para el retrato
  int estado = AV_NORMAL;
  int previo = AV_NORMAL;
  float mezcla = 1;                  // 0..1 transicion entre expresiones
  float pop = 0;                     // rebote al cambiar de expresion
  boolean alerta = false;

  AvatarView() {
    String[] nombres = {"normal", "feliz", "preocupada", "sorprendida"};
    for (int i = 0; i < 4; i++) {
      File f = new File(dataPath("avatar_" + nombres[i] + ".png"));
      if (f.exists()) {
        cuerpo[i] = loadImage("avatar_" + nombres[i] + ".png");
        busto[i] = cuerpo[i].get(0, 0, cuerpo[i].width, int(cuerpo[i].height * 0.42));
      }
    }
  }

  int estadoPara(float bienestar, boolean spam) {
    if (spam) return AV_SORPRENDIDA;
    if (bienestar > 70) return AV_FELIZ;
    if (bienestar < 50) return AV_PREOCUPADA;
    return AV_NORMAL;
  }

  void actualizar(float bienestar, boolean spam) {
    int nuevo = estadoPara(bienestar, spam);
    if (nuevo != estado) {
      previo = estado;
      estado = nuevo;
      mezcla = 0;
      pop = 1;
    }
    alerta = spam;
    mezcla = lerp(mezcla, 1, 0.2);
    if (mezcla > 0.98) mezcla = 1;
    pop = lerp(pop, 0, 0.15);
  }

  int colorEstado() {
    if (estado == AV_SORPRENDIDA) return COL_ROJO;
    if (estado == AV_PREOCUPADA)  return COL_AMARILLO;
    if (estado == AV_FELIZ)       return COL_VERDE;
    return COL_BORDE;
  }

  // Retrato enmarcado (esquina superior izquierda del juego). x, y, w, h en px de la imagen original.
  void dibujarRetrato(float x, float y, float w, float h, float bienestar, boolean spam) {
    actualizar(bienestar, spam);

    float pulso = alerta ? 0.5 + 0.5 * sin(millis() * 0.012) : 0;
    int borde = lerpColor(colorEstado(), color(255), pulso * 0.4);
    panelRetro(x, y, w, h, #1B2154, 240, borde);

    float m = 16;
    // fondo del retrato
    rectMode(CORNER);
    noStroke();
    fill(#2F3680);
    rect(sx(x + m), sy(y + m), ss(w - 2 * m), ss(h - 2 * m), ss(6));
    fill(255, 14);
    for (int i = 0; i < 6; i++) rect(sx(x + m), sy(y + m + i * 52), ss(w - 2 * m), ss(26));

    clip(sx(x + m), sy(y + m), ss(w - 2 * m), ss(h - 2 * m));
    if (mezcla < 1) dibujarBusto(previo, x, y, w, h, 255 * (1 - mezcla));
    dibujarBusto(estado, x, y, w, h, 255 * mezcla);
    noClip();

    // Etiqueta de alerta
    if (alerta && (millis() / 280) % 2 == 0) {
      float bw = 250, bh = 54;
      float bx = x + w / 2 - bw / 2;
      float by = y + h - m - bh - 6;
      noStroke();
      fill(COL_ROJO);
      rect(sx(bx), sy(by), ss(bw), ss(bh), ss(8));
      textoRetro("¡ALERTA!", x + w / 2, by + bh / 2, 40, color(255), CENTER, CENTER);
    }
    rectMode(CORNER);
  }

  void dibujarBusto(int est, float x, float y, float w, float h, float alfa) {
    float m = 16;
    float cx = x + w / 2;
    float temblor = alerta ? sin(millis() * 0.05) * 4 : 0;
    if (busto[est] == null) {
      tint(255, alfa);
      caritaRespaldo(est, sx(cx + temblor), sy(y + h / 2), ss(h * 0.30));
      noTint();
      return;
    }
    PImage b = busto[est];
    float alto = (h - 2 * m) * (1 + 0.07 * pop);
    float ancho = b.width * alto / b.height;
    imageMode(CORNER);
    tint(255, alfa);
    image(b, sx(cx - ancho / 2 + temblor), sy(y + m), ss(ancho), ss(alto));
    noTint();
  }

  // Cuerpo completo (pantalla de creditos). xCentro y ypies en px de la imagen original.
  void dibujarCuerpo(float xCentro, float yPies, float alto, int est) {
    float rebote = sin(millis() * 0.004) * 6;
    if (cuerpo[est] == null) {
      caritaRespaldo(est, sx(xCentro), sy(yPies - alto / 2), ss(alto * 0.2));
      return;
    }
    PImage c = cuerpo[est];
    float ancho = c.width * alto / c.height;
    imageMode(CORNER);
    image(c, sx(xCentro - ancho / 2), sy(yPies - alto + rebote), ss(ancho), ss(alto));
  }

  void caritaRespaldo(int est, float cx, float cy, float r) {
    int humor = H_NEUTRAL;
    if (est == AV_FELIZ) humor = H_FELIZ;
    else if (est == AV_PREOCUPADA) humor = H_TRISTE;
    else if (est == AV_SORPRENDIDA) humor = H_SORPRESA;
    caritaRetro(cx, cy, r, humor, color(255, 205, 150));
  }
}
