// PantallaJuego - interfaz visual del simulador de moderacion (pantallas[1]).
//
// SOLO se encarga de DIBUJAR. La logica (que mensaje sigue, cuanto vale cada accion,
// cuando hay spam) la maneja el back-end y le habla a esta clase con:
//
//   setPuntaje(int)      setBienestar(float 0..100)    setSpam(boolean)
//   setMensaje(MessageCard)    mostrarResultado(acierto, puntos)
//   consumirAccion()            -> 0 BLOQUEAR, 1 REPORTAR, 2 REFORMULAR, 3 APROBAR, o -1 si no hubo
//
// modoDemo = true deja el juego "funcionando solo" con mensajes de ejemplo para probar el
// diseno. Cuando el back-end conecte su logica, ponerlo en false.
//   Teclas de prueba (solo en demo):  flechas arriba/abajo = bienestar,  S = spam,  N = otro mensaje

class PantallaJuego extends Pantalla {
  int puntaje = 1575;
  float bienestar = 82;
  boolean spam = false;
  float puntajeVis = 1575;        // valores "animados" que se ven en pantalla
  float bienestarVis = 82;

  MessageCard mensaje;
  AvatarView avatar;
  int accionPendiente = -1;

  // efectos de resultado
  int flashColor = 0;
  int flashT0 = -9999;
  String flotante = "";
  int flotanteColor = 0;
  int flotanteT0 = -9999;

  // demo
  boolean modoDemo = true;
  MessageCard[] demoMensajes;
  int demoIdx = 0;

  PantallaJuego(String nombre, PImage fondo, AvatarView avatar) {
    super(nombre, fondo, 4); // Cuatro botones configurados
    this.avatar = avatar;

    // Cuatro botones centrados bajo la ventana
    float bw = 230, bh = 250, sep = 20, y0 = 715;
    float x0 = 1370 - (4 * bw + 3 * sep) / 2;
    Ponerboton(0, new BotonRetro("BLOQUEAR",   "B", x0,                     y0, bw, bh, fondo), -1);
    Ponerboton(1, new BotonRetro("REPORTAR",   "R", x0 + (bw + sep),       y0, bw, bh, fondo), -1);
    Ponerboton(2, new BotonRetro("REFORMULAR", "E", x0 + 2 * (bw + sep),   y0, bw, bh, fondo), -1);
    Ponerboton(3, new BotonRetro("APROBAR",    "A", x0 + 3 * (bw + sep),   y0, bw, bh, fondo), -1);

    demoMensajes = new MessageCard[] {
      new MessageCard("Usuario99",   "¡Este juego es una pérdida de tiempo!", MSG_NEGATIVO),
      new MessageCard("xX_Luna_Xx",   "Me encantó tu foto de ayer, quedaste genial :)",      MSG_POSITIVO),
      new MessageCard("Mateo_04",    "¿Alguien sabe a qué hora es la reunión de mañana?",   MSG_NEUTRAL),
      new MessageCard("AnonimoXD",   "Nadie te quiere aquí, mejor cierra tu cuenta.",        MSG_NEGATIVO),
      new MessageCard("Camila_R",    "Gracias por ayudarme con el trabajo, eres lo máximo", MSG_POSITIVO)
    };
    mensaje = demoMensajes[0];
  }

  // ---------- API para el back-end ----------

  void setPuntaje(int p)            { puntaje = p; }
  void setBienestar(float b)        { bienestar = constrain(b, 0, 100); }
  void setSpam(boolean s)            { spam = s; }
  void setMensaje(MessageCard m)    { mensaje = m; if (m != null) m.reiniciar(); }

  // Destello del marco + numerito flotante (+100 / -50)
  void mostrarResultado(boolean acierto, int puntos) {
    flashColor = acierto ? COL_VERDE : COL_ROJO;
    flashT0 = millis();
    flotante = (puntos >= 0 ? "+" : "") + puntos;
    flotanteColor = flashColor;
    flotanteT0 = millis();
  }

  // Devuelve la ultima accion elegida (y la borra). -1 si no hubo ninguna.
  int consumirAccion() {
    int a = accionPendiente;
    accionPendiente = -1;
    return a;
  }

  // ---------- Entrada ----------

  void disparar(int cual) {
    botones[cual].presionar();
    accionPendiente = cual;
    if (modoDemo) demoResolver(cual);
  }

  int click() {
    for (int j = 0; j < botones.length; j++) {
      if (botones[j].estaEncima(mouseX, mouseY)) {
        disparar(j);
        return -1;                // se queda en esta pantalla
      }
    }
    return -1;
  }

  // Lo llama B3hind_T3xt.pde desde keyPressed()
  void teclaPresionada(char k, int code) {
    char c = Character.toUpperCase(k);
    if (c == 'B') disparar(0);
    else if (c == 'R') disparar(1);
    else if (c == 'E') disparar(2);
    else if (c == 'A') disparar(3); // Tecla A para Aprobar
    else if (modoDemo) {
      if (k == CODED && code == UP)    bienestar = constrain(bienestar + 10, 0, 100);
      if (k == CODED && code == DOWN) bienestar = constrain(bienestar - 10, 0, 100);
      if (c == 'S') spam = !spam;
      if (c == 'N') demoSiguiente();
    }
  }

  // ---------- Dibujo ----------

  void draw() {
    puntajeVis = lerp(puntajeVis, puntaje, 0.12);
    bienestarVis = lerp(bienestarVis, bienestar, 0.12);

    dibujarHUD();
    avatar.dibujarRetrato(101, 161, 488, 329, bienestar, spam);
    dibujarVentana();
    if (mensaje != null) {
      mensaje.dibujar(905, 345, 930, 330);
    } else {
      textoRetro("BANDEJA VACÍA", 1370, 520, 54, COL_GRIS, CENTER, CENTER);
    }
    super.draw();                      // botones + cursor
    dibujarFlotante();

    rectMode(CORNER);
    imageMode(CORNER);
  }

  void dibujarHUD() {
    // PUNTAJE (izquierda)
    String sp = "PUNTAJE: " + int(round(puntajeVis));
    textoRetro(sp, 60, 40, 64, COL_TEXTO, LEFT, TOP);
    textFont(fuentePixel);
    textSize(ss(64));
    float anchoRef = textWidth(sp) / escalaFondo;
    corazonPixel(60 + anchoRef + 26, 42, 9, COL_ROSA, 255);

    // BIENESTAR (derecha) con barra de segmentos
    int bi = int(round(bienestarVis));
    int colBarra = bienestarVis > 70 ? COL_VERDE : (bienestarVis < 50 ? COL_ROJO : COL_AMARILLO);
    String sb = "BIENESTAR: " + bi + "%";
    textoRetro(sb, REF_W - 150, 40, 64, COL_TEXTO, RIGHT, TOP);
    float latido = (bienestarVis < 30) ? 0.55 + 0.45 * sin(millis() * 0.012) : 1;
    corazonPixel(REF_W - 130, 42, 9, COL_ROJO, 255 * latido);

    float bx = REF_W - 60 - 540, by = 128, bw = 540, bh = 28;
    int segs = 20;
    float segW = (bw - (segs - 1) * 4) / segs;
    rectMode(CORNER);
    stroke(255, 90);
    strokeWeight(max(1, ss(3)));
    fill(0, 120);
    rect(sx(bx - 8), sy(by - 8), ss(bw + 16), ss(bh + 16), ss(8));
    noStroke();
    for (int i = 0; i < segs; i++) {
      boolean lleno = (i + 0.5) / segs * 100 <= bienestarVis;
      fill(lleno ? colBarra : color(255, 30));
      rect(sx(bx + i * (segW + 4)), sy(by), ss(segW), ss(bh), ss(3));
    }
    strokeWeight(1);
  }

  void dibujarVentana() {
    float vx = 881, vy = 189, vw = 978, vh = 508;
    panelRetro(vx, vy, vw, vh, COL_PANEL, 238, COL_BORDE);

    // destello de acierto / error
    float k = (millis() - flashT0) / 450.0;
    if (k >= 0 && k < 1) {
      rectMode(CORNER);
      noFill();
      stroke(flashColor, 255 * (1 - k));
      strokeWeight(max(2, ss(12)));
      rect(sx(vx), sy(vy), ss(vw), ss(vh), ss(12));
      noStroke();
      strokeWeight(1);
    }

    textoRetro("MODERACIÓN DE MENSAJE", vx + vw / 2, vy + 56, 52, COL_TITULO, CENTER, CENTER);
    stroke(255, 70);
    strokeWeight(max(1, ss(3)));
    line(sx(vx + 40), sy(vy + 100), sx(vx + vw - 40), sy(vy + 100));
    noStroke();
    strokeWeight(1);

    if (spam) {
      boolean on = (millis() / 300) % 2 == 0;
      textoRetro("¡ALERTA: PATRÓN DE SPAM!", vx + vw / 2, vy + 134, 38, on ? COL_ROJO : COL_AMARILLO, CENTER, CENTER);
    } else {
      textoRetro("REVISIÓN EN CURSO", vx + vw / 2, vy + 134, 36, #D5DEF5, CENTER, CENTER);
    }
  }

  void dibujarFlotante() {
    float k = (millis() - flotanteT0) / 1000.0;
    if (k < 0 || k >= 1) return;
    float a = 255 * (1 - k * k);
    float y = 700 - 120 * easeOut(k);
    textFont(fuentePixel);
    textAlign(CENTER, CENTER);
    textSize(ss(96));
    fill(0, a * 0.6);
    text(flotante, sx(1370) + ss(5), sy(y) + ss(6));
    fill(flotanteColor, a);
    text(flotante, sx(1370), sy(y));
  }

  // ---------- Demo (reemplazable por la logica real) ----------

  void demoResolver(int accion) {
    boolean acierto = false;
    if (mensaje != null) {
      if (mensaje.tipo == MSG_NEGATIVO) {
        acierto = (accion == 0 || accion == 1); // Bloquear o Reportar
      } else if (mensaje.tipo == MSG_POSITIVO) {
        acierto = (accion == 3); // Aprobar es correcto para mensajes positivos
      } else {
        acierto = (accion == 2); // Reformular para neutrales u otros
      }
    }
    int pts = acierto ? 100 : -50;
    puntaje = max(0, puntaje + pts);
    bienestar = constrain(bienestar + (acierto ? 3 : -8), 0, 100);
    mostrarResultado(acierto, pts);
    demoSiguiente();
  }

  void demoSiguiente() {
    demoIdx = (demoIdx + 1) % demoMensajes.length;
    setMensaje(demoMensajes[demoIdx]);
  }
}
