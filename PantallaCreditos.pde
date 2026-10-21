// PantallaCreditos - pantalla de creditos (pantallas[3]).
// Ventana estilo escritorio de los 2000 con las tarjetas del equipo y un boton VOLVER
// que lleva al menu (destino 0), igual que el resto de la navegacion.

class PantallaCreditos extends Pantalla {
  String[] nombres = {"Anghelo Ospino", "Samantha Pertuz", "Gemini"};
  String[] roles   = {"BACK-END & INTEGRATOR", "FRONT-END & INTEGRATOR", "AI ART & ASSETS"};
  int[] colRol     = {#4FA3FF, #FF6FB5, #3DDC84};

  AvatarView avatar;
  int tEntrada = 0;
  int ultimoFrame = -10;

  // ... (el resto del constructor y métodos se mantienen igual)
  PantallaCreditos(String nombre, PImage fondo, AvatarView avatar) {
    super(nombre, fondo, 1);
    this.avatar = avatar;
    Ponerboton(0, new BotonRetro("VOLVER", "ESC", 1240, 1070, 480, 110, fondo), 0);
  }

  void draw() {
    // Si no se dibujaba en el frame anterior, acabamos de entrar: reinicia la animacion
    if (frameCount - ultimoFrame > 1) tEntrada = millis();
    ultimoFrame = frameCount;

    dibujarAvatar();
    dibujarVentana();
    super.draw();                    // boton + cursor

    rectMode(CORNER);
    imageMode(CORNER);
  }

  void dibujarAvatar() {
    // globo de despedida
    panelRetro(125, 150, 480, 110, COL_PANEL, 235, COL_BORDE);
    float t = tamQueCabe("¡Gracias por jugar!", ss(420), ss(40));
    textoPx("¡Gracias por jugar!", sx(365), sy(205), t, COL_TEXTO, CENTER, CENTER);
    avatar.dibujarCuerpo(365, 1250, 940, AV_FELIZ);
  }

  void dibujarVentana() {
    float vx = 700, vy = 140, vw = 1560, vh = 880;
    float barra = 72;

    // sombra y cuerpo de la ventana
    rectMode(CORNER);
    noStroke();
    fill(0, 110);
    rect(sx(vx) + ss(10), sy(vy) + ss(10), ss(vw), ss(vh), ss(12));
    stroke(COL_BORDE);
    strokeWeight(max(1.5, ss(4)));
    fill(#17204A);
    rect(sx(vx), sy(vy), ss(vw), ss(vh), ss(12));

    // barra de titulo con degradado
    noStroke();
    int tramos = 48;
    float tw = vw / tramos;
    for (int i = 0; i < tramos; i++) {
      fill(lerpColor(#2B3A8C, #6C86F0, i / (float) tramos));
      float rIzq = (i == 0) ? ss(12) : 0;
      float rDer = (i == tramos - 1) ? ss(12) : 0;
      rect(sx(vx + i * tw), sy(vy), ss(tw) + 1, ss(barra), rIzq, rDer, 0, 0);
    }
    // borde de la ventana encima de la barra
    noFill();
    stroke(COL_BORDE);
    strokeWeight(max(1.5, ss(4)));
    rect(sx(vx), sy(vy), ss(vw), ss(vh), ss(12));
    noStroke();
    textoRetro("creditos.exe", vx + 30, vy + barra / 2, 38, color(255), LEFT, CENTER);
    for (int i = 0; i < 3; i++) {   // botoncitos decorativos
      float bx = vx + vw - 30 - 46 - i * 58;
      fill(i == 0 ? COL_ROJO : #C9D6FF);
      stroke(255, 160);
      strokeWeight(max(1, ss(2)));
      rect(sx(bx), sy(vy + 14), ss(46), ss(44), ss(6));
    }
    noStroke();
    strokeWeight(1);

    // titulo del juego
    textoRetro("B3HIND T3XT", vx + vw / 2, vy + 170, 104, #7DF9FF, CENTER, CENTER);
    textoRetro("Think B4 U send.", vx + vw / 2, vy + 255, 46, #FF9AD1, CENTER, CENTER);

    textoRetro("EQUIPO DE DESARROLLO", vx + vw / 2, vy + 335, 36, COL_TITULO, CENTER, CENTER);
    stroke(255, 70);
    strokeWeight(max(1, ss(3)));
    line(sx(vx + 70), sy(vy + 368), sx(vx + vw - 70), sy(vy + 368));
    noStroke();
    strokeWeight(1);

    // tarjetas del equipo, entran una tras otra
float cw = 440, ch = 360, sep = 50;
    float x0 = vx + (vw - (nombres.length * cw + (nombres.length - 1) * sep)) / 2;
    for (int i = 0; i < nombres.length; i++) {
      float e = easeOut((millis() - tEntrada - 150 - i * 140) / 420.0);
      dibujarTarjeta(i, x0 + i * (cw + sep), vy + 400 + 70 * (1 - e), cw, ch);
    }

    textoRetro("Universidad del Norte · Algoritmia y Programación II", vx + vw / 2, vy + 810, 34, #9FB0E0, CENTER, CENTER);
    textoRetro("Laboratorio de bienestar digital", vx + vw / 2, vy + 852, 30, #7384BB, CENTER, CENTER);
    rectMode(CORNER);
  }

  void dibujarTarjeta(int i, float x, float y, float w, float h) {
    int col = colRol[i];
    panelRetro(x, y, w, h, #1F2A5E, 255, col);

    // insignia con iniciales
    float cx = x + w / 2;
    ellipseMode(CENTER);
    noStroke();
    fill(col);
    ellipse(sx(cx), sy(y + 100), ss(124), ss(124));
    fill(255, 60);
    ellipse(sx(cx - 14), sy(y + 74), ss(60), ss(34));
    textoRetro(iniciales(nombres[i]), cx, y + 102, 60, #17204A, CENTER, CENTER);

    // nombre ajustado al ancho de la tarjeta
    float t = tamQueCabe(nombres[i], ss(w - 50), ss(44));
    textoPx(nombres[i], sx(cx), sy(y + 214), t, COL_TEXTO, CENTER, CENTER);

    // etiqueta del rol
    rectMode(CENTER);
    fill(col);
    rect(sx(cx), sy(y + 288), ss(280), ss(56), ss(10));
    float tr = tamQueCabe(roles[i], ss(250), ss(34));
    textoPx(roles[i], sx(cx), sy(y + 289), tr, #17204A, CENTER, CENTER);
    rectMode(CORNER);
  }

  String iniciales(String nombre) {
    String[] partes = split(nombre, ' ');
    String r = "";
    for (String p : partes) {
      if (p.length() > 0) r += p.substring(0, 1).toUpperCase();
    }
    return r;
  }
}
