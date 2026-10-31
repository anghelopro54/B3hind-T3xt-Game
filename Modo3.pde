// MODO 3: DE-ESCALATE!
// Ivana modera conflictos en Vinculo: lee la situacion y elige la respuesta ASERTIVA entre tres.
// Hereda de Pantalla (pantallas[8]). Reutiliza lo que ya existe en el proyecto:
//   Avatar, MenuPausa, fuente, escalaFondo / offsetX / offsetY, imagenCover() y JUGANDO / VICTORIA / DERROTA (Modo1.pde)
// Todo se define en coordenadas del canvas 1920x1080, igual que el resto de pantallas.
//
// Archivos que debe haber en la carpeta data:
//   fondo_modo3.jpg (o .png)   -> escritorio con el monitor (la pantalla negra es donde va la ventana)
//   Alertatroll.png (o .jpg)   -> cartel "ALERTA TROLL" (sin fondo; se recorta solo el borde transparente)

// fases dentro de un caso
final int FASE_ELEGIR = 0;      // el jugador lee el conflicto y elige una respuesta
final int FASE_RESULTADO = 1;   // se explica por que la respuesta funciono (o no); clic / ENTER para seguir

// Un conflicto: la opcion 0 SIEMPRE es la asertiva (se barajan al mostrarlas, asi no cae siempre en la A)
class Caso {
  String titulo;
  String participantes;
  String texto;
  String[] opciones = new String[3];    // 0 = asertiva, 1 = agresiva, 2 = pasiva
  String[] retro = new String[3];       // por que funciona / por que no

  Caso(String titulo, String participantes, String texto,
       String asertiva, String retroAsertiva,
       String agresiva, String retroAgresiva,
       String pasiva, String retroPasiva) {
    this.titulo = titulo;
    this.participantes = participantes;
    this.texto = texto;
    opciones[0] = asertiva;   retro[0] = retroAsertiva;
    opciones[1] = agresiva;   retro[1] = retroAgresiva;
    opciones[2] = pasiva;     retro[2] = retroPasiva;
  }
}

class Modo3 extends Pantalla {
  // ---------- geometria (canvas 1920x1080) ----------
  // Ventana "Conflicto.exe": cabe dentro de la pantalla negra del monitor de fondo_modo3
  // (zona negra aprox. x 625-1307, y 225-717). Ajusta estos valores y mira el resultado con la tecla D.
  float vx = 640, vy = 238, vw = 652, vh = 466;
  float barraH = 40;        // barra de titulo
  float trollH = 118;       // alto del cartel ALERTA TROLL (el ancho sale de su proporcion)
  float franjaH = 34;       // franja de ayuda al pie de la ventana

  // Botones de respuesta (debajo del monitor, sobre el teclado)
  float opW = 400, opH = 160, opGap = 30, opY = 890;
  float opX0;               // se centra en el constructor

  // ---------- reglas ----------
  final int TOTAL_CASOS = 5;                    // casos por partida (salen al azar del banco)
  final float BIENESTAR_INICIAL = 80;
  final float BIENESTAR_ACIERTO = 10;           // respuesta asertiva: suma bienestar
  final float BIENESTAR_ERROR = 15;             // respuesta agresiva o pasiva: resta bienestar
  final int PUNTOS_ACIERTO = 20;                // acertar a la primera
  final int PUNTOS_ACIERTO_CON_ERRORES = 10;    // acertar despues de fallar
  final int PANTALLA_MODOS = 4;                 // pantallas[4] = seleccion de modos (al ganar se vuelve ahi)

  Avatar avatar;
  PImage alertaTroll;
  ArrayList<Caso> banco = new ArrayList<Caso>();      // todos los conflictos disponibles
  ArrayList<Caso> partida = new ArrayList<Caso>();    // los que tocan en esta partida
  Caso caso;
  int casoActual = 0;

  int[] orden = {0, 1, 2};                  // orden[posicion en pantalla] = opcion del caso (0 = asertiva)
  boolean[] descartada = new boolean[3];    // respuestas ya falladas en este caso
  int errores = 0;                          // fallos en este caso
  int fase = FASE_ELEGIR;
  boolean acierto = false;                  // resultado de la ultima respuesta (en FASE_RESULTADO)
  int elegida = -1;                         // posicion del boton que se pulso
  String retro = "";
  String tituloRes = "";

  // tamanos de letra calculados para que cada texto quepa en su caja
  float tamTitulo, tamTexto, tamRetro, tamTituloRes;
  float[] tamOpcion = new float[3];

  int estado = JUGANDO;
  int puntos = 0;
  int sacudidaHasta = 0;                    // el troll tiembla al fallar
  float[] brillo = new float[3];            // animacion al pasar el mouse por los botones

  // pausa (igual que el Modo 1)
  MenuPausa menuPausa = new MenuPausa();
  boolean pausado = false;
  boolean volviendoDeConfig = false;        // true mientras se esta en Configuracion abierta desde la pausa

  Modo3() {
    super("MODO 3", crearFondoModo3(), 0);
    opX0 = (1920 - (3 * opW + 2 * opGap)) / 2;

    PImage t = cargarImagenAlguna(new String[] {"Alertatroll.png", "Alertatroll.jpg", "alertatroll.png", "alertatroll.jpg"});
    alertaTroll = (t != null) ? recortarTransparente(quitarFondo(t)) : null;

    avatar = new Avatar(40, 1080 - 40 - 250, 250, BIENESTAR_INICIAL);
    crearCasos();
    reiniciar();
  }

  void reiniciar() {
    // al volver de Configuracion (abierta desde la pausa) se conserva la partida
    if (volviendoDeConfig) {
      volviendoDeConfig = false;
      return;
    }
    pausado = false;
    estado = JUGANDO;
    puntos = 0;
    avatar.bienestar = BIENESTAR_INICIAL;
    avatar.limpiarReaccion();
    armarPartida();
    casoActual = 0;
    cargarCaso();
  }

  // ---------- casos ----------

  // Baraja el banco (Fisher-Yates) y se queda con TOTAL_CASOS
  void armarPartida() {
    partida.clear();
    for (Caso c : banco) partida.add(c);
    for (int i = partida.size() - 1; i > 0; i--) {
      int j = (int) random(i + 1);
      Caso tmp = partida.get(i);
      partida.set(i, partida.get(j));
      partida.set(j, tmp);
    }
    while (partida.size() > TOTAL_CASOS) partida.remove(partida.size() - 1);
  }

  void cargarCaso() {
    caso = partida.get(casoActual);

    // barajar donde cae cada respuesta
    orden[0] = 0;
    orden[1] = 1;
    orden[2] = 2;
    for (int i = 2; i > 0; i--) {
      int j = (int) random(i + 1);
      int tmp = orden[i];
      orden[i] = orden[j];
      orden[j] = tmp;
    }
    for (int i = 0; i < 3; i++) {
      descartada[i] = false;
      brillo[i] = 0;
    }
    errores = 0;
    fase = FASE_ELEGIR;
    elegida = -1;
    retro = "";

    // letra mas grande con la que cada texto cabe en su caja (se calcula una vez por caso)
    tamTitulo = ajustarTamano(caso.titulo, infoW(), 56, 30, 16);
    tamTexto = ajustarTamano(caso.texto, papelW() - 24, papelH() - 20, 26, 14);
    for (int i = 0; i < 3; i++) {
      tamOpcion[i] = ajustarTamano(caso.opciones[orden[i]], opW - 32, opH - 40, 22, 13);
    }
  }

  // ---------- logica ----------

  // pos = posicion del boton (0 = A, 1 = B, 2 = C)
  void elegir(int pos) {
    if (fase != FASE_ELEGIR || descartada[pos]) return;
    int op = orden[pos];
    elegida = pos;
    fase = FASE_RESULTADO;

    if (op == 0) {
      acierto = true;
      avatar.cambiarBienestar(BIENESTAR_ACIERTO);
      avatar.reaccionar(FELIZ);                       // sonrie al calmar el conflicto
      puntos += (errores == 0) ? PUNTOS_ACIERTO : PUNTOS_ACIERTO_CON_ERRORES;
      tituloRes = "¡CONFLICTO RESUELTO!  BIENESTAR +" + (int) BIENESTAR_ACIERTO;
    } else {
      acierto = false;
      errores++;
      descartada[pos] = true;
      avatar.cambiarBienestar(-BIENESTAR_ERROR);
      // reacciona al instante: confundida al primer tropiezo, frustrada si ya estaba mal
      avatar.reaccionar(avatar.estado() == FELIZ ? CONFUNDIDA : FRUSTRADA);
      sacudidaHasta = millis() + 500;
      tituloRes = "¡EL CONFLICTO ESCALÓ!  BIENESTAR -" + (int) BIENESTAR_ERROR;
    }
    retro = caso.retro[op];
    tamTituloRes = ajustarTamano(tituloRes, papelW() - 24, 36, 28, 16);
    tamRetro = ajustarTamano(retro, papelW() - 24, papelH() - 66, 26, 14);
  }

  // Cierra la explicacion: avanza de caso, termina la partida o deja reintentar
  void continuar() {
    if (fase != FASE_RESULTADO) return;
    avatar.limpiarReaccion();                         // la cara vuelve a depender del bienestar
    if (acierto) {
      casoActual++;
      if (casoActual >= partida.size()) estado = VICTORIA;
      else cargarCaso();
    } else if (avatar.bienestar <= 0) {
      estado = DERROTA;
    } else {
      fase = FASE_ELEGIR;
      elegida = -1;
    }
  }

  // ---------- entrada ----------

  boolean capturaEsc() {
    return estado == JUGANDO;      // si la partida termino, ESC vuelve al menu como siempre
  }

  int indiceEnPantallas() {
    for (int i = 0; i < pantallas.length; i++) if (pantallas[i] == this) return i;
    return 0;
  }

  void tecla(char k) {
    if (k == ESC) {
      if (estado == JUGANDO) pausado = !pausado;
      return;
    }
    if (pausado) return;
    if (estado != JUGANDO) {
      if (k == ENTER || k == RETURN) reiniciar();
      return;
    }
    if (fase == FASE_RESULTADO) {
      if (k == ENTER || k == RETURN || k == ' ') continuar();
      return;
    }
    if (k == 'a' || k == 'A' || k == '1') elegir(0);
    else if (k == 'b' || k == 'B' || k == '2') elegir(1);
    else if (k == 'c' || k == 'C' || k == '3') elegir(2);
  }

  // Boton de respuesta bajo el mouse (0, 1 o 2) o -1. Las ya falladas no responden.
  int encima() {
    if (pausado || estado != JUGANDO || fase != FASE_ELEGIR) return -1;
    float e = escalaFondo;
    for (int i = 0; i < 3; i++) {
      if (descartada[i]) continue;
      float x = pantX(opXi(i));
      float y = pantY(opY);
      if (mouseX >= x && mouseX <= x + opW * e && mouseY >= y && mouseY <= y + opH * e) return i;
    }
    return -1;
  }

  int click() {
    if (pausado) {
      int op = menuPausa.click();
      if (op == 0) {                         // Reanudar
        pausado = false;
      } else if (op == 1) {                  // Configuracion (al darle Volver regresa aqui)
        volviendoDeConfig = true;
        configVolverA = indiceEnPantallas();
        return 2;
      } else if (op == 2) {                  // Salir al menu
        pausado = false;
        return 0;
      }
      return -1;
    }
    if (estado == VICTORIA) return PANTALLA_MODOS;           // victoria: de vuelta a la seleccion de modos
    if (estado == DERROTA) {                                 // derrota: reintentar
      reiniciar();
      return -1;
    }
    if (fase == FASE_RESULTADO) {
      continuar();
      return -1;
    }
    int i = encima();
    if (i >= 0) elegir(i);
    return -1;
  }

  // ---------- geometria auxiliar ----------

  float pantX(float cx) { return offsetX + cx * escalaFondo; }    // canvas -> ventana
  float pantY(float cy) { return offsetY + cy * escalaFondo; }

  float opXi(int i) { return opX0 + i * (opW + opGap); }

  float trollW() {
    if (alertaTroll == null) return 150;
    return trollH * alertaTroll.width / alertaTroll.height;
  }
  float infoY() { return vy + barraH + 10; }                    // fila del cartel y los datos del caso
  float infoX() { return vx + 16 + trollW() + 16; }
  float infoW() { return vx + vw - 16 - infoX(); }
  float papelX() { return vx + 16; }                            // "hoja" con el texto del conflicto
  float papelW() { return vw - 32; }
  float papelY() { return infoY() + trollH + 10; }
  float franjaY() { return vy + vh - 14 - franjaH; }
  float papelH() { return franjaY() - 8 - papelY(); }

  // Texto dentro de una caja dada en canvas (usa el textAlign / fill que haya puesto quien llama)
  void textoCaja(String s, float sz, float x, float y, float w, float h) {
    float e = escalaFondo;
    textSize(sz * e);
    textLeading(sz * 1.25 * e);
    text(s, pantX(x), pantY(y), w * e, h * e + 4 * e);
  }

  // ---------- dibujo ----------

  void draw() {
    cursor(ARROW);

    pushMatrix();
    translate(0, round(sin(frameCount * 0.05) * 1.5));   // acompana el vaiven del fondo

    dibujarVentana();
    dibujarOpciones();
    dibujarHud();
    avatar.dibujar();
    if (debug) dibujarDebug();
    if (estado != JUGANDO) dibujarFin();
    if (pausado) menuPausa.dibujar();

    popMatrix();
  }

  void dibujarVentana() {
    float e = escalaFondo;
    pushStyle();
    rectMode(CORNER);
    imageMode(CORNER);
    textFont(fuente);

    // cuerpo de la ventana (mismo estilo que las ventanas XP del menu)
    fill(94, 104, 115);
    stroke(140, 70, 200);
    strokeWeight(8 * e);
    rect(pantX(vx), pantY(vy), vw * e, vh * e, 10 * e);

    // barra de titulo
    noStroke();
    fill(140, 70, 200);
    rect(pantX(vx), pantY(vy), vw * e, barraH * e, 10 * e, 10 * e, 0, 0);
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(22 * e);
    text("Conflicto.exe", pantX(vx + 16), pantY(vy + barraH / 2));

    // botones decorativos de la barra
    stroke(255);
    strokeWeight(2 * e);
    fill(70, 142, 224);
    rect(pantX(vx + vw - 132), pantY(vy + 8), 34 * e, 24 * e, 8 * e);
    rect(pantX(vx + vw - 90), pantY(vy + 8), 34 * e, 24 * e, 8 * e);
    fill(250, 12, 12);
    rect(pantX(vx + vw - 48), pantY(vy + 8), 34 * e, 24 * e, 8 * e);

    // fila superior: cartel ALERTA TROLL + datos del caso
    float ty = infoY();
    dibujarTroll(vx + 16, ty, trollW(), trollH);

    noStroke();
    textAlign(LEFT, TOP);
    fill(255, 220, 120);
    textSize(24 * e);
    text("CASO " + (casoActual + 1) + " / " + partida.size(), pantX(infoX()), pantY(ty + 2));
    fill(255);
    textoCaja(caso.titulo, tamTitulo, infoX(), ty + 34, infoW(), 56);
    fill(200, 210, 255);
    textoCaja(caso.participantes, 18, infoX(), ty + 94, infoW(), 24);

    // "hoja" con el conflicto (o con la explicacion de la respuesta)
    fill(235, 238, 250);
    stroke(20, 20, 60);
    strokeWeight(4 * e);
    rect(pantX(papelX()), pantY(papelY()), papelW() * e, papelH() * e, 8 * e);
    noStroke();
    textAlign(LEFT, TOP);
    if (fase == FASE_ELEGIR) {
      fill(20, 20, 60);
      textoCaja(caso.texto, tamTexto, papelX() + 12, papelY() + 10, papelW() - 24, papelH() - 20);
    } else {
      fill(acierto ? color(20, 130, 60) : color(190, 30, 40));
      textoCaja(tituloRes, tamTituloRes, papelX() + 12, papelY() + 10, papelW() - 24, 40);
      fill(20, 20, 60);
      textoCaja(retro, tamRetro, papelX() + 12, papelY() + 56, papelW() - 24, papelH() - 66);
    }

    // franja inferior: ayuda o "continuar"
    fill(10, 10, 30, 215);
    rect(pantX(papelX()), pantY(franjaY()), papelW() * e, franjaH * e, 8 * e);
    textAlign(CENTER, CENTER);
    textSize(18 * e);
    float fcx = pantX(papelX() + papelW() / 2);
    float fcy = pantY(franjaY() + franjaH / 2);
    if (fase == FASE_ELEGIR) {
      fill(200, 210, 255);
      text("Elige tu respuesta:   [A]   [B]   [C]", fcx, fcy);
    } else if ((millis() / 400) % 2 == 0) {
      fill(255, 220, 120);
      text("Clic o ENTER para continuar", fcx, fcy);
    }
    popStyle();
  }

  // Cartel ALERTA TROLL: flota, tiembla al fallar y se apaga con sello "RESUELTO" al acertar
  void dibujarTroll(float x, float y, float w, float h) {
    float e = escalaFondo;
    boolean temblando = millis() < sacudidaHasta;
    float dx = temblando ? sin(millis() * 0.09) * 7 : 0;
    float dy = sin(frameCount * 0.12) * 2;
    boolean resuelto = (fase == FASE_RESULTADO && acierto);

    pushStyle();
    imageMode(CORNER);
    if (alertaTroll != null) {
      if (resuelto) tint(255, 110);
      image(alertaTroll, pantX(x + dx), pantY(y + dy), w * e, h * e);
      noTint();
    } else {
      // respaldo si falta la imagen
      rectMode(CORNER);
      fill(80, 200, 120);
      stroke(20, 60, 40);
      strokeWeight(4 * e);
      rect(pantX(x + dx), pantY(y + dy), w * e, h * e, 10 * e);
      noStroke();
      fill(20, 60, 40);
      textFont(fuente);
      textAlign(CENTER, CENTER);
      textSize(20 * e);
      text("ALERTA TROLL", pantX(x + dx + w / 2), pantY(y + dy + h / 2));
    }
    if (resuelto) {
      pushMatrix();
      translate(pantX(x + w / 2), pantY(y + h / 2));
      rotate(radians(-12));
      rectMode(CENTER);
      fill(90, 220, 120);
      stroke(20, 60, 30);
      strokeWeight(4 * e);
      rect(0, 0, (w - 6) * e, 34 * e, 6 * e);
      noStroke();
      fill(20, 60, 30);
      textFont(fuente);
      textAlign(CENTER, CENTER);
      textSize(22 * e);
      text("RESUELTO", 0, 0);
      popMatrix();
    }
    popStyle();
  }

  void dibujarOpciones() {
    float e = escalaFondo;
    int sobre = encima();
    if (sobre >= 0) cursor(HAND);

    pushStyle();
    rectMode(CORNER);
    ellipseMode(CENTER);
    textFont(fuente);
    String[] letras = {"A", "B", "C"};

    for (int i = 0; i < 3; i++) {
      brillo[i] = lerp(brillo[i], (i == sobre) ? 1 : 0, 0.2);
      boolean pulsada = (fase == FASE_RESULTADO && i == elegida);

      int relleno, borde, tinta;
      if (pulsada && acierto) {                       // la respuesta asertiva
        relleno = color(120, 220, 140);
        borde = color(20, 60, 30);
        tinta = color(20, 60, 30);
      } else if (pulsada || descartada[i]) {          // una respuesta fallada
        relleno = color(215, 120, 125);
        borde = color(110, 20, 30);
        tinta = color(90, 15, 25);
      } else if (fase == FASE_RESULTADO) {            // las demas, apagadas mientras se lee la explicacion
        relleno = color(120, 130, 165);
        borde = color(20, 20, 60);
        tinta = color(45, 50, 90);
      } else {
        relleno = lerpColor(color(150, 179, 230), color(200, 220, 255), brillo[i]);
        borde = color(20, 20, 60);
        tinta = color(20, 20, 60);
      }

      float k = 1 + 0.05 * brillo[i];
      float w = opW * e * k;
      float h = opH * e * k;
      float cx = pantX(opXi(i) + opW / 2);
      float cy = pantY(opY + opH / 2);

      fill(relleno);
      stroke(borde);
      strokeWeight(6 * e);
      rect(cx - w / 2, cy - h / 2, w, h, 20 * e);

      // texto de la respuesta
      noStroke();
      fill(tinta);
      textAlign(CENTER, CENTER);
      textoCaja(caso.opciones[orden[i]], tamOpcion[i], opXi(i) + 16, opY + 30, opW - 32, opH - 40);

      // letra de la opcion (A, B o C) colgando de la esquina
      fill(140, 70, 200);
      stroke(20, 20, 60);
      strokeWeight(4 * e);
      ellipse(pantX(opXi(i) + 34), pantY(opY + 2), 52 * e, 52 * e);
      noStroke();
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(30 * e);
      text(letras[i], pantX(opXi(i) + 34), pantY(opY + 2));
    }
    popStyle();
  }

  void dibujarHud() {
    float e = escalaFondo;
    pushStyle();
    rectMode(CORNER);
    textFont(fuente);

    float px = pantX(30), py = pantY(30), pw = 290 * e, ph = 140 * e;
    noStroke();
    fill(10, 10, 30, 215);
    rect(px, py, pw, ph, 10 * e);

    textAlign(LEFT, TOP);
    fill(255);
    textSize(20 * e);
    text("BIENESTAR", px + 15 * e, py + 12 * e);
    fill(60, 60, 90);
    rect(px + 15 * e, py + 40 * e, pw - 30 * e, 20 * e, 4 * e);
    fill(avatar.colorEstado());
    rect(px + 15 * e, py + 40 * e, (pw - 30 * e) * avatar.bienestar / 100.0, 20 * e, 4 * e);

    fill(255);
    text("CASO  " + min(casoActual + 1, partida.size()) + " / " + partida.size(), px + 15 * e, py + 76 * e);
    text("PUNTOS  " + puntos, px + 15 * e, py + 106 * e);
    popStyle();
  }

  // Tecla D: zonas de la ventana y de los botones
  void dibujarDebug() {
    float e = escalaFondo;
    pushStyle();
    rectMode(CORNER);
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    rect(pantX(vx), pantY(vy), vw * e, vh * e);
    for (int i = 0; i < 3; i++) rect(pantX(opXi(i)), pantY(opY), opW * e, opH * e);
    stroke(255, 255, 0);
    rect(pantX(625), pantY(225), 682 * e, 492 * e);    // pantalla negra del monitor (referencia)
    popStyle();
  }

  void dibujarFin() {
    float e = escalaFondo;
    boolean gano = (estado == VICTORIA);
    pushStyle();
    rectMode(CORNER);
    noStroke();
    fill(0, 190);
    rect(offsetX, offsetY, 1920 * e, 1080 * e);
    textFont(fuente);
    textAlign(CENTER, CENTER);
    fill(gano ? color(90, 220, 120) : color(240, 70, 70));
    textSize(64 * e);
    text(gano ? "¡CONFLICTOS RESUELTOS!" : "LA SITUACIÓN SE DESCONTROLÓ", pantX(960), pantY(440));
    fill(255);
    textSize(28 * e);
    if (gano) text("Ivana calmó la red.   Puntos: " + puntos + "   Bienestar: " + (int) avatar.bienestar, pantX(960), pantY(520));
    else      text("Puntos: " + puntos + "   Casos resueltos: " + casoActual + " / " + partida.size(), pantX(960), pantY(520));
    textSize(24 * e);
    if (gano) text("Clic: elegir otro modo   ·   ENTER: jugar de nuevo   ·   ESC: menú principal", pantX(960), pantY(590));
    else      text("Clic o ENTER para reintentar   ·   ESC para volver al menú", pantX(960), pantY(590));
    popStyle();
  }

  // ---------- banco de conflictos ----------
  // Orden de cada caso: asertiva, agresiva, pasiva (cada una con su explicacion).
  // Tono: conversacion normal, nombres comunes y sin groserias ni insultos (las respuestas malas se notan por
  // su actitud: amenazar o ignorar). Mantener los textos cortos: caso <= ~190 caracteres, respuestas <= ~125, explicaciones <= ~110.
  void crearCasos() {
    banco.add(new Caso(
      "Burla en una foto",
      "Camila   y   Andrés",
      "Andrés comentó en la foto de Camila: \"Qué foto tan rara, mejor bórrala\". Varias personas reaccionaron con risas y Camila respondió: \"Eres muy grosero, no vuelvas a escribirme\".",
      "Andrés, ese comentario incomodó a Camila; te pido que lo borres. Camila, entiendo tu molestia; hablemos por privado.",
      "Describes lo ocurrido sin acusar, pides una acción concreta y ofreces un espacio tranquilo para hablar.",
      "Los dos se están comportando mal. Si siguen así, voy a suspender sus cuentas.",
      "Amenazar con sanciones los pone a la defensiva y la discusión se hace más grande.",
      "Mejor no intervenir, seguro se les pasa solo. Silencio el hilo y ya.",
      "Ignorarlo no ayuda: las risas continúan y Camila se queda sola frente a las burlas."));

    banco.add(new Caso(
      "Rumor en el grupo",
      "Laura   en   Grupo de Cálculo II",
      "En el grupo circula una captura que dice que Laura copió en el parcial. Nadie lo ha comprobado, pero ya hay varios comentarios en su contra. Laura escribe: \"Es mentira\".",
      "Es un rumor sin pruebas; dejemos de compartir la captura. Laura, cuéntanos tu versión con calma y lo revisamos.",
      "Frenas la propagación, no culpas a nadie y le das a Laura la oportunidad de explicarse.",
      "Dejen de hablar de lo que no saben. Quien vuelva a compartir la captura será suspendido.",
      "Regañar a todos y amenazar cierra el diálogo: la gente se defiende en lugar de escuchar.",
      "Laura, no les prestes atención, ya se les pasará. Quizá es mejor que no entres al grupo unos días.",
      "Pedirle que se aleje no resuelve el rumor ni la protege; el problema sigue creciendo."));

    banco.add(new Caso(
      "Discusión tras un partido",
      "Sebastián   y   Mateo",
      "Tras perder un partido en línea, Sebastián le escribió a Mateo: \"Jugaste mal y nos hiciste perder\". Mateo respondió ofendiendo a la familia de Sebastián y el chat se llenó de espectadores.",
      "Perder frustra, lo entiendo. Hablen de la jugada y no de la persona, y dejen a las familias fuera. ¿Revancha mañana?",
      "Reconoces la frustración, separas la jugada de la persona y llevas la energía hacia algo positivo.",
      "Están actuando como niños. Aprendan a perder o salgan del servidor.",
      "Burlarte de su reacción los hace sentir juzgados y alimenta la pelea; una ofensa no se corrige con otra.",
      "No me corresponde opinar, resuélvanlo entre ustedes.",
      "Mantenerte al margen parece neutral, pero el chat lo toma como permiso para seguir con las ofensas."));

    banco.add(new Caso(
      "La nueva del grupo",
      "María   en   Comunidad de Programación",
      "María, nueva en la comunidad, hizo una pregunta básica. Alguien le respondió: \"Eso se busca en Google, no hagas perder el tiempo\". Ella escribió: \"Mejor me salgo del grupo\".",
      "María, tu pregunta es válida. Te dejo una guía y aquí sigo para ayudarte. Les pido a todos responder con respeto.",
      "Reconoces a María, le das ayuda real y recuerdas la norma del grupo sin atacar a nadie.",
      "Quien le respondió así fue grosero. Voy a poner una advertencia pública para todos.",
      "Una advertencia general incomoda a quienes no hicieron nada y deja a María en el centro de la atención.",
      "María, no les hagas caso. Si te sientes mal, quizá es mejor que te salgas.",
      "Pedirle que se vaya castiga a quien recibió el mal trato, y en la comunidad todo sigue igual."));

    banco.add(new Caso(
      "Hilo fuera de control",
      "Daniela   y   el hilo",
      "Alguien publicó un comentario antiguo de Daniela. El hilo ya tiene 300 respuestas y Julián escribe: \"Pásenme su dirección y voy a hablar con ella\".",
      "Compartir datos personales está prohibido y puede hacer daño. Si hay quejas, repórtenlas y las revisamos. Cierro el hilo.",
      "Marcas un límite claro, ofreces un camino correcto (reportar) y proteges a Daniela sin humillar a nadie.",
      "Todos ustedes están actuando muy mal. Suspendo las cuentas de quienes participaron.",
      "Sancionar en masa te enfrenta con todo el hilo y no explica qué se hizo mal.",
      "Es solo una conversación en internet, nadie va a ir a ningún lado. No exageren.",
      "Minimizar una amenaza real es peligroso: pedir una dirección es acoso y hay que detenerlo ya."));

    banco.add(new Caso(
      "Mensajes sin respuesta",
      "Valentina   y   Daniel",
      "Valentina escribió: \"Llevas una semana sin responderme, no te importa nuestra amistad\". Daniel contestó: \"Estaba en exámenes, no seas exagerada\". Ahora ninguno quiere hablar.",
      "Valentina, te sentiste ignorada y eso duele. Daniel, estabas ocupado, no fue tu intención. Cuéntense cómo se sintieron.",
      "Reconoces lo que cada uno sintió sin culpar a nadie. Hablar en primera persona abre la conversación.",
      "Valentina, no exageres. Daniel, responder un mensaje toma un minuto.",
      "Decirle exagerada a alguien invalida lo que siente: los dos terminan sintiéndose juzgados.",
      "Son cosas que pasan. Mejor no hablen del tema.",
      "Esconder el problema no lo borra: queda el resentimiento y la amistad se enfría en silencio."));

    banco.add(new Caso(
      "Interrupciones en directo",
      "Tomás   y   Ricardo",
      "En la transmisión en vivo de Tomás, Ricardo llena el chat con el mismo mensaje cada diez segundos. Tomás responde: \"Si vuelves a entrar, te reporto\" y el chat se divide en bandos.",
      "Ricardo, repetir mensajes interrumpe la transmisión: por favor, para o te silencio diez minutos. Tomás, gracias por la calma.",
      "Pones un límite claro con una consecuencia concreta y reconoces a quien mantuvo la calma.",
      "Ricardo, estás arruinando todo. Fuera de aquí, te bloqueo para siempre.",
      "Atacar a Ricardo le da lo que busca: una reacción. Responder con ofensas solo lo motiva a seguir.",
      "El chat es así, hay que aguantarse. Que cada uno haga lo que quiera.",
      "Dejar que continúe castiga a todo el chat y le dice a Ricardo que no hay consecuencias."));
  }
}

// ---------- utilidades (fuera de la clase, como crearFondoModo1 / imagenCover) ----------

// Fondo del modo 3: fondo_modo3 a pantalla completa (usa imagenCover de PantallaJuego.pde)
PGraphics crearFondoModo3() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  pg.background(40, 30, 70);                      // por si falta la imagen
  PImage img = cargarImagenAlguna(new String[] {"fondo_modo3.jpg", "fondo_modo3.png", "Fondo_modo3.jpg", "Fondo_modo3.png"});
  if (img != null) {
    imagenCover(pg, img);
  } else {
    pg.noStroke();
    pg.fill(0);
    pg.rect(625, 225, 682, 492, 30);              // monitor de respaldo
  }
  pg.endDraw();
  return pg;
}

// Carga la primera imagen que exista en data (sin llenar la consola de errores). null si no hay ninguna.
PImage cargarImagenAlguna(String[] nombres) {
  for (String n : nombres) {
    if (new File(dataPath(n)).exists()) return loadImage(n);
  }
  return null;
}

// Si la imagen NO trae transparencia (por ejemplo un JPG con fondo negro o blanco), vuelve transparente
// el fondo liso. Parte de los bordes y avanza solo por pixeles parecidos al color de la esquina,
// asi no borra los negros del interior del dibujo. Si ya trae transparencia, la devuelve igual.
PImage quitarFondo(PImage img) {
  img.loadPixels();
  int w = img.width, h = img.height;
  int[] px = img.pixels;
  if (alpha(px[0]) < 250) {
    // Ya trae transparencia. OJO: si el archivo es un PNG guardado con extension .jpg, Processing
    // lo carga como RGB e ignora el alfa (los pixeles transparentes salen NEGROS). Se copia a ARGB.
    PImage listo = createImage(w, h, ARGB);
    listo.loadPixels();
    System.arraycopy(px, 0, listo.pixels, 0, w * h);
    listo.updatePixels();
    return listo;
  }

  int bg = px[0];
  float br = red(bg), bgr = green(bg), bb = blue(bg);
  boolean[] visto = new boolean[w * h];
  int[] pila = new int[w * h];
  int n = 0;

  // semillas: todos los pixeles del borde que se parezcan al fondo
  for (int x = 0; x < w; x++) {
    int a = x, b = (h - 1) * w + x;
    if (!visto[a] && parecidoA(px[a], br, bgr, bb)) { visto[a] = true; pila[n++] = a; }
    if (!visto[b] && parecidoA(px[b], br, bgr, bb)) { visto[b] = true; pila[n++] = b; }
  }
  for (int y = 0; y < h; y++) {
    int a = y * w, b = y * w + w - 1;
    if (!visto[a] && parecidoA(px[a], br, bgr, bb)) { visto[a] = true; pila[n++] = a; }
    if (!visto[b] && parecidoA(px[b], br, bgr, bb)) { visto[b] = true; pila[n++] = b; }
  }

  // relleno por inundacion hacia adentro
  while (n > 0) {
    int i = pila[--n];
    int x = i % w, y = i / w;
    if (x > 0     && !visto[i - 1] && parecidoA(px[i - 1], br, bgr, bb)) { visto[i - 1] = true; pila[n++] = i - 1; }
    if (x < w - 1 && !visto[i + 1] && parecidoA(px[i + 1], br, bgr, bb)) { visto[i + 1] = true; pila[n++] = i + 1; }
    if (y > 0     && !visto[i - w] && parecidoA(px[i - w], br, bgr, bb)) { visto[i - w] = true; pila[n++] = i - w; }
    if (y < h - 1 && !visto[i + w] && parecidoA(px[i + w], br, bgr, bb)) { visto[i + w] = true; pila[n++] = i + w; }
  }

  PImage out = createImage(w, h, ARGB);
  out.loadPixels();
  for (int i = 0; i < w * h; i++) out.pixels[i] = visto[i] ? 0 : (px[i] | 0xFF000000);
  out.updatePixels();
  return out;
}

// true si el color c se parece a (r, g, b); la tolerancia absorbe el ruido de compresion del JPG
boolean parecidoA(int c, float r, float g, float b) {
  return abs(red(c) - r) + abs(green(c) - g) + abs(blue(c) - b) < 90;
}

// Quita el borde transparente de un PNG (si la imagen no tiene transparencia, la devuelve igual)
PImage recortarTransparente(PImage img) {
  img.loadPixels();
  int minX = img.width, minY = img.height, maxX = -1, maxY = -1;
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      if (alpha(img.pixels[y * img.width + x]) > 20) {
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
  }
  if (maxX < 0) return img;
  return img.get(minX, minY, maxX - minX + 1, maxY - minY + 1);
}

// Cuantas lineas ocupa un texto en una caja de ese ancho, con el textFont / textSize actuales
int contarLineasTexto(String s, float ancho) {
  String[] palabras = split(s, " ");
  int lineas = 1;
  String actual = "";
  for (String p : palabras) {
    String prueba = actual.length() == 0 ? p : actual + " " + p;
    if (textWidth(prueba) <= ancho) actual = prueba;
    else {
      lineas++;
      actual = p;
    }
  }
  return lineas;
}

// Mayor tamano de letra (entre minSz y maxSz) con el que el texto cabe en una caja ancho x alto
float ajustarTamano(String s, float ancho, float alto, float maxSz, float minSz) {
  pushStyle();
  textFont(fuente);
  float sz = maxSz;
  while (sz > minSz) {
    textSize(sz);
    if (contarLineasTexto(s, ancho * 0.96) * sz * 1.25 <= alto) break;
    sz -= 1;
  }
  popStyle();
  return sz;
}
