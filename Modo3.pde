// =====================================================================================
// MODO 3 (en el menu aparece como "MODO 2"): DE-ESCALATE!
// Ivana modera conflictos en Vinculo: lee la situacion y elige la respuesta ASERTIVA entre tres
// (las otras dos son una agresiva y una pasiva). Hereda de ModoJuego (pausa, puntos, avatar, estado).
// Todo se define en coordenadas del canvas 1920x1080, igual que el resto de pantallas.
//
// Archivos que debe haber en la carpeta data:
//   fondo_modo3.jpg (o .png)   -> escritorio con el monitor (la pantalla negra es donde va la ventana)
//   Alertatroll.png (o .jpg)   -> cartel "ALERTA TROLL" (sin fondo; se recorta solo el borde transparente)
//   casos_modo3.txt            -> los conflictos del juego (ver ese archivo para agregar mas)
// =====================================================================================

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
    opciones[0] = asertiva;
    retro[0] = retroAsertiva;
    opciones[1] = agresiva;
    retro[1] = retroAgresiva;
    opciones[2] = pasiva;
    retro[2] = retroPasiva;
  }
}

class Modo3 extends ModoJuego {
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
  final int PUNTOS_ACIERTO = 60;                // acertar a la primera
  final int PUNTOS_ACIERTO_CON_ERRORES = 30;    // acertar despues de fallar

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

  int sacudidaHasta = 0;                    // el troll tiembla al fallar
  float[] brillo = new float[3];            // animacion al pasar el mouse por los botones

  Modo3() {
    super("MODO 3", crearFondoModo3(invent.equipado[FONDO_M3]), 3);
    fondoAplicado = invent.equipado[FONDO_M3];
    opX0 = (1920 - (3 * opW + 2 * opGap)) / 2;

    PImage t = cargarImagenAlguna(new String[] {"Alertatroll.png", "Alertatroll.jpg", "alertatroll.png", "alertatroll.jpg"});
    alertaTroll = (t != null) ? recortarTransparente(quitarFondo(t)) : null;

    avatar = new Avatar(40, 1080 - 40 - 250, 250, BIENESTAR_INICIAL);
    crearCasos();
    reiniciar();
  }

  // Armado del fondo del modo (lo usa ModoJuego al equipar otro fondo)
  PGraphics crearFondo(int variante) {
    return crearFondoModo3(variante);
  }

  // Empieza una partida nueva (se llama al entrar al modo)
  void reiniciar() {
    if (!prepararReinicio(invent.equipado[FONDO_M3])) return;   // false = solo se volvia de Configuracion
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

  // Prepara el caso actual: baraja el orden de las respuestas y calcula el tamano de letra de cada texto
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

    depositarPuntos();      // si la partida termino, los puntos pasan a la billetera (una sola vez)
  }

  // ---------- entrada ----------

  // Teclas del modo: A/B/C (o 1/2/3) eligen respuesta; ENTER o espacio continua tras leer la explicacion
  void tecla(char k) {
    if (teclaComun(k)) return;
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

  // Clic: en pausa maneja el menu; si no, elige una respuesta o continua tras la explicacion
  int click() {
    if (pausado) return clickPausa();
    if (estado == VICTORIA) return P_MODOS;           // victoria: de vuelta a la seleccion de modos
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

  // Un cuadro: dibuja la ventana del conflicto, las 3 opciones, el panel y el avatar
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

  // Dibuja la ventana "Conflicto.exe": cartel troll, datos del caso, hoja con el texto y franja de ayuda
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

  // Dibuja los 3 botones de respuesta (colores distintos si acertaste, fallaste o estan apagados)
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
      boolean normal = false;

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
        normal = true;
        relleno = lerpColor(color(150, 179, 230), color(200, 220, 255), brillo[i]);
        borde = color(20, 20, 60);
        tinta = color(20, 20, 60);
      }

      float k = 1 + 0.05 * brillo[i];
      float w = opW * e * k;
      float h = opH * e * k;
      float cx = pantX(opXi(i) + opW / 2);
      float cy = pantY(opY + opH / 2);

      marcoOpcion(cx - w / 2, cy - h / 2, w, h, relleno, borde, invent.equipado[BORDE_M3], normal);

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

  // Panel de bienestar, caso actual y puntos
  void dibujarHud() {
    float e = escalaFondo;
    pushStyle();
    rectMode(CORNER);
    textFont(fuente);

    dibujarPanelBienestar(140);          // panel con la barra de bienestar (de ModoJuego)
    float px = pantX(30), py = pantY(30);

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

  // Pantalla final de victoria o derrota (usa la plantilla de ModoJuego)
  void dibujarFin() {
    boolean gano = (estado == VICTORIA);
    String resumen = gano ? "Ivana calmó la red.   Puntos: " + puntos + "   Bienestar: " + (int) avatar.bienestar
                          : "Puntos: " + puntos + "   Casos resueltos: " + casoActual + " / " + partida.size();
    String ayuda = gano ? "Clic: elegir otro modo   ·   ENTER: jugar de nuevo   ·   ESC: menú principal"
                        : "Clic o ENTER para reintentar   ·   ESC para volver al menú";
    dibujarFin("¡CONFLICTOS RESUELTOS!", "LA SITUACIÓN SE DESCONTROLÓ", resumen, ayuda);
  }

  // ---------- banco de conflictos ----------
  // Los casos estan en data/casos_modo3.txt (una linea por caso, 9 campos separados por |). Ver ese archivo
  // para agregar o editar casos sin tocar el codigo. Cada partida elige TOTAL_CASOS al azar.
  void crearCasos() {
    String[] lineas = loadStrings(dataPath("casos_modo3.txt"));
    if (lineas == null) lineas = new String[0];
    for (String l : lineas) {
      l = l.trim();
      if (l.length() == 0 || l.startsWith("#")) continue;         // lineas vacias o comentarios
      String[] c = split(l, '|');
      if (c.length < 9) {
        println("casos_modo3.txt: linea con menos de 9 campos, se ignora: " + l);
        continue;
      }
      for (int k = 0; k < c.length; k++) c[k] = c[k].trim();
      banco.add(new Caso(c[0], c[1], c[2], c[3], c[4], c[5], c[6], c[7], c[8]));
    }
    // Sin el archivo el juego igual funciona (con un solo caso de emergencia)
    if (banco.isEmpty()) {
      println("No se encontro data/casos_modo3.txt: se usa un caso de emergencia.");
      banco.add(new Caso("Burla en una foto", "Camila   y   Andrés",
        "Andrés comentó en la foto de Camila: \"Qué foto tan rara, mejor bórrala\".",
        "Andrés, ese comentario incomodó a Camila; bórralo, por favor.", "Describes lo ocurrido sin acusar y pides una acción concreta.",
        "Andrés, eres un abusivo. Si pasa otra vez, te saco del grupo.", "Amenazar los pone a la defensiva.",
        "Cada uno tiene su punto. Dejemos que se enfríe.", "Ignorarlo no ayuda: las burlas continúan."));
    }
  }
}

// Fondo del modo 3: fondo_modo3.jpg (o la variante comprada en la tienda: fondo_modo3_2.jpg ...)
PGraphics crearFondoModo3(int variante) {
  return crearFondoVariante(new String[] {"fondo_modo3", "Fondo_modo3"}, variante, true);
}
