// =====================================================================================
// MODO 1: FLAGGED & FILTERED
// Caen mensajes de usuarios por la pantalla del monitor. El jugador debe BLOQUEAR (tecla B) los toxicos
// y APROBAR (tecla A) los sanos antes de que lleguen al final. Cada 4 bloqueos puede REPORTAR (tecla R).
// Hereda de ModoJuego (pausa, puntos, avatar, estado) y esta en pantallas[P_MODO1].
// =====================================================================================
class Modo1 extends ModoJuego {
  // Zona blanca de la ventana "Clasificacion" en PrimerModo.jpg (canvas 1920x1080).
  // Si quieres moverla, ajusta estos valores y mira el resultado con la tecla D.
  float campoX = 358, campoY = 172, campoW = 1226, campoH = 694;

  float msgW = 380, msgH = 122;         // tamano de cada mensaje
  float[] carriles = new float[3];      // x de cada carril donde caen los mensajes
  final int MAX_MENSAJES = 5;           // maximo de mensajes en pantalla a la vez
  final float PROB_TOXICO = 0.5;        // probabilidad de que el siguiente sea toxico
  final int RACHA_MAX = 3;              // maximo de mensajes seguidos del mismo tipo
  int ultimoTipo = -1;
  int racha = 0;

  // "Bolsas" de mensajes: se sacan sin repetir hasta que se acaban, luego se vuelven a barajar
  ArrayList<String> bolsaToxicos = new ArrayList<String>();
  ArrayList<String> bolsaSanos = new ArrayList<String>();

  final int META_PUNTOS = 400;          // puntos para ganar
  final int PUNTOS_REPORTE = 30;        // puntos extra al reportar (cambia aqui el valor)
  final int BLOQUEOS_PARA_REPORTE = 4;  // bloqueos necesarios para poder reportar

  ArrayList<Mensaje> mensajes = new ArrayList<Mensaje>();   // mensajes que estan cayendo ahora
  int bloqueados = 0;                   // toxicos bloqueados seguidos (al llegar a BLOQUEOS_PARA_REPORTE se puede reportar)
  int ultimoMs = 0;                     // millis() del cuadro anterior (para calcular dt)
  int proximoSpawn = 0;                 // millis() en que aparece el siguiente mensaje
  String aviso = "";                    // texto temporal de la barra inferior
  int avisoHasta = 0;                   // millis() hasta el que se muestra el aviso
  int inicioPausa = 0;                  // millis() en que empezo la pausa (para compensar los temporizadores)

  // Textos de los mensajes que caen (se reparten sin repetir, ver sacarTexto)
  String[] usuarios = {"user_2231", "lunita_09", "DarkMoth", "pixel_fan", "kevin.r", "nat_uninorte", "gamer404", "sofi_p",
    "xX_shadow_Xx", "camii.rios", "el_pana_07", "valeeee", "noctis_", "dani_c", "maria.dev", "tomi2003"};
  String[] toxicos = {
    "Nadie te quiere aquí, desinstala la app",
    "Eres una inútil, mejor cállate ya",
    "Te voy a encontrar y vas a pagar",
    "Qué asco de persona, todos te odian",
    "Ojalá desaparezcas, a nadie le importas",
    "Jajaja qué fracasada, borra tu cuenta",
    "Sube otra foto y te destrozamos entre todos",
    "Das pena, nadie quiere ser tu amigo",
    "Eres tan fea que da miedo abrir tu perfil",
    "Cállate, nadie pidió tu opinión, estúpida",
    "Voy a publicar tu dirección a ver qué pasa",
    "Mejor no vuelvas al colegio, todos se burlan",
    "Tu familia debe estar avergonzada de ti",
    "Eres un perdedor, deja de escribir",
    "Todos en el grupo hablan mal de ti",
    "Si sigues subiendo cosas te vamos a funar",
    "Qué patética, das vergüenza ajena",
    "Nadie te va a ayudar, te lo mereces",
    "Voy a hacer que te echen de la universidad",
    "Qué cara de tonta, seguro no entiendes nada",
    "Te conseguí tu número, prepárate",
    "Eres basura, el mundo estaría mejor sin ti",
    "Ni tu mamá te soporta, inútil",
    "Borra ese video o te arrepentirás",
    "Qué risa me das, siempre solita y llorando"
  };
  String[] sanos = {
    "Gracias por ayudarme con la tarea",
    "¿Alguien juega esta noche a las 8?",
    "Qué buena foto, me encantó el paisaje",
    "Feliz cumple, que la pases genial",
    "Ánimo con el examen, tú puedes",
    "Compartí mi receta, cuéntenme qué tal",
    "Me encantó tu canción nueva",
    "¿Puedes explicarme el ejercicio 3?",
    "Buenos días a todos, que tengan un gran día",
    "Gracias por el consejo, me sirvió muchísimo",
    "¿Alguien tiene los apuntes de la clase de hoy?",
    "Felicidades por tu ascenso, te lo mereces",
    "Qué rabia, se me acabó la batería a mitad del juego",
    "Estoy en desacuerdo, pero respeto tu opinión",
    "Recomiéndenme una serie para este fin de semana",
    "Te mando un abrazo, espero que estés mejor",
    "Buen partido ayer, jugaste muy bien",
    "¿A qué hora es la reunión del proyecto?",
    "Perdón por la demora, ya te envío el archivo",
    "Mi gato aprendió a abrir la puerta, miren",
    "Gracias por defender a mi amigo, eres un crack",
    "Me equivoqué en el cálculo, gracias por avisarme",
    "Vamos por unos helados después de clase",
    "Qué lindo dibujo, ¿me enseñas a hacerlo?",
    "Si necesitas hablar, aquí estoy para ti"
  };

  Modo1() {
    super("MODO 1", crearFondoModo1(invent.equipado[FONDO_M1]), 1);
    fondoAplicado = invent.equipado[FONDO_M1];
    // reparte los 3 carriles de caida a lo ancho del monitor
    float hueco = (campoW - 24 - carriles.length * msgW) / (carriles.length - 1);
    for (int i = 0; i < carriles.length; i++) carriles[i] = campoX + 12 + i * (msgW + hueco);
    avatar = new Avatar(40, 1080 - 40 - 250, 250, 80);
    reiniciar();
  }

  // Armado del fondo del modo (lo usa ModoJuego al equipar otro fondo)
  PGraphics crearFondo(int variante) {
    return crearFondoModo1(variante);
  }

  // Empieza una partida nueva (se llama al entrar al modo)
  void reiniciar() {
    if (!prepararReinicio(invent.equipado[FONDO_M1])) return;   // false = solo se volvia de Configuracion
    mensajes.clear();
    bolsaToxicos.clear();
    bolsaSanos.clear();
    ultimoTipo = -1;
    racha = 0;
    bloqueados = 0;
    avatar.bienestar = 80;
    aviso = "";
    ultimoMs = millis();
    proximoSpawn = millis() + 800;
  }

  // ---------- logica ----------

  // Un paso del juego: mueve los mensajes, crea nuevos y revisa si termino la partida
  void actualizar() {
    int ahora = millis();
    float dt = min((ahora - ultimoMs) / 1000.0, 0.1);
    ultimoMs = ahora;

    if (ahora >= proximoSpawn) {
      generarMensaje();
      proximoSpawn = ahora + int(max(1300, 3000 - puntos * 8) + random(-250, 250));
    }

    float yFin = campoY + campoH;
    for (int i = mensajes.size() - 1; i >= 0; i--) {
      Mensaje m = mensajes.get(i);
      m.mover(dt);
      if (m.llegoAlFinal(yFin)) {
        // se escapo sin clasificar
        if (m.tipo == TOXICO) {
          avatar.cambiarBienestar(-15);
          avisar("Un mensaje tóxico llegó al final  -15");
        } else {
          avatar.cambiarBienestar(-5);
          avisar("Dejaste pasar un mensaje sano  -5");
        }
        mensajes.remove(i);
      }
    }

    if (puntos >= META_PUNTOS) estado = VICTORIA;
    else if (avatar.bienestar <= 0) estado = DERROTA;

    depositarPuntos();      // si la partida termino, los puntos pasan a la billetera (una sola vez)
  }

  // Crea un mensaje nuevo en un carril libre
  void generarMensaje() {
    if (mensajes.size() >= MAX_MENSAJES) return;      // no saturar la pantalla

    // elegir carril libre al azar
    int carril = int(random(carriles.length));
    int elegido = -1;
    for (int k = 0; k < carriles.length; k++) {
      int c = (carril + k) % carriles.length;
      if (carrilLibre(carriles[c])) {
        elegido = c;
        break;
      }
    }
    if (elegido < 0) return;

    int tipo = elegirTipo();
    String texto = sacarTexto(tipo);
    String usuario = usuarios[int(random(usuarios.length))];
    float vel = 90 + puntos * 0.2 + random(1, 4);
    mensajes.add(new Mensaje(tipo, usuario, texto, carriles[elegido], campoY - msgH, msgW, msgH, vel));
  }

  // Tipo del siguiente mensaje: al azar, pero sin pasar de RACHA_MAX seguidos del mismo tipo
  int elegirTipo() {
    int tipo = random(1) < PROB_TOXICO ? TOXICO : SANO;
    if (tipo == ultimoTipo && racha >= RACHA_MAX) tipo = (tipo == TOXICO) ? SANO : TOXICO;
    racha = (tipo == ultimoTipo) ? racha + 1 : 1;
    ultimoTipo = tipo;
    return tipo;
  }

  // Saca un texto de la bolsa del tipo dado (sin repetir hasta agotarla)
  String sacarTexto(int tipo) {
    ArrayList<String> bolsa = (tipo == TOXICO) ? bolsaToxicos : bolsaSanos;
    String[] fuenteTextos = (tipo == TOXICO) ? toxicos : sanos;
    if (bolsa.isEmpty()) {
      for (String s : fuenteTextos) bolsa.add(s);
      for (int i = bolsa.size() - 1; i > 0; i--) {      // barajar (Fisher-Yates)
        int j = int(random(i + 1));
        String tmp = bolsa.get(i);
        bolsa.set(i, bolsa.get(j));
        bolsa.set(j, tmp);
      }
    }
    return bolsa.remove(bolsa.size() - 1);
  }

  // Hay espacio arriba del carril? (evita que se encimen los mensajes)
  boolean carrilLibre(float cx) {
    for (Mensaje m : mensajes) {
      if (m.x == cx && m.y < campoY + 40) return false;
    }
    return true;
  }

  // El mensaje que se resuelve con [B] / [A] es el mas cercano al final
  Mensaje objetivo() {
    Mensaje elegido = null;
    for (Mensaje m : mensajes) {
      if (elegido == null || m.y > elegido.y) elegido = m;
    }
    return elegido;
  }

  // decision: TOXICO = bloquear, SANO = aprobar
  void clasificar(int decision) {
    Mensaje m = objetivo();
    if (m == null) return;
    mensajes.remove(m);

    if (m.tipo == decision) {
      puntos += 10;
      avatar.cambiarBienestar(2);
      if (decision == TOXICO) bloqueados = min(bloqueados + 1, BLOQUEOS_PARA_REPORTE);
      avisar("¡Correcto!  +10");
    } else if (decision == SANO) {
      avatar.cambiarBienestar(-15);       // aprobaste un mensaje toxico
      avisar("Aprobaste un mensaje tóxico  -15");
    } else {
      avatar.cambiarBienestar(-8);        // bloqueaste un mensaje sano
      avisar("Bloqueaste un mensaje sano  -8");
    }
  }

  // Tecla R: con suficientes bloqueos da bienestar y puntos extra
  void reportar() {
    if (bloqueados >= BLOQUEOS_PARA_REPORTE) {
      bloqueados = 0;
      avatar.cambiarBienestar(20);
      puntos += PUNTOS_REPORTE;
      avisar("Reporte enviado  +20 bienestar  +" + PUNTOS_REPORTE + " puntos");
    } else {
      avisar("Aún no tienes " + BLOQUEOS_PARA_REPORTE + " bloqueos para reportar");
    }
  }

  // Muestra un texto en la barra inferior durante 1.8 segundos
  void avisar(String t) {
    aviso = t;
    avisoHasta = millis() + 1800;
  }

  // ---------- entrada ----------

  // Al reanudar se corren los temporizadores el tiempo que duro la pausa (si no, caerian mensajes de golpe)
  void alternarPausa() {
    if (!pausado) {
      inicioPausa = millis();
    } else {
      int dur = millis() - inicioPausa;
      proximoSpawn += dur;
      avisoHasta += dur;
      ultimoMs = millis();
    }
    super.alternarPausa();
  }

  // Teclas del modo: B = bloquear, A = aprobar, R = reportar (ESC y ENTER las maneja ModoJuego)
  void tecla(char k) {
    if (teclaComun(k)) return;
    if (k == 'b' || k == 'B') clasificar(TOXICO);
    else if (k == 'a' || k == 'A') clasificar(SANO);
    else if (k == 'r' || k == 'R') reportar();
  }

  // Clic: en pausa maneja el menu; al terminar la partida vuelve a la eleccion de modos
  int click() {
    if (pausado) return clickPausa();
    if (estado != JUGANDO) return P_MODOS;     // fin de partida: un clic vuelve a la eleccion de modos
    return -1;
  }

  // ---------- dibujo ----------

  // Un cuadro: actualiza la logica (si no hay pausa) y dibuja todo
  void draw() {
    cursor(ARROW);
    if (estado == JUGANDO && !pausado) actualizar();

    pushMatrix();
    translate(0, round(sin(frameCount * 0.05) * 1.5));   // acompana el vaiven del fondo

    dibujarMensajes();
    dibujarHud();
    dibujarAvisoReporte();
    avatar.dibujar();
    if (estado != JUGANDO) dibujarFin();
    if (pausado) menuPausa.dibujar();

    popMatrix();
  }

  // Dibuja los mensajes recortados a la zona del monitor, con la linea roja de peligro abajo
  void dibujarMensajes() {
    float e = escalaFondo;
    float cx = offsetX + campoX * e;
    float cy = offsetY + campoY * e;
    float cw = campoW * e;
    float ch = campoH * e;

    clip(cx, cy, cw, ch);                   // los mensajes "nacen" dentro de la pantalla del monitor
    Mensaje obj = objetivo();
    for (Mensaje m : mensajes) m.dibujar(m == obj);
    noClip();

    pushStyle();
    rectMode(CORNER);
    noStroke();
    fill(255, 60, 60, 110);                 // linea de peligro (borde inferior)
    rect(cx, cy + ch - 4 * e, cw, 4 * e);
    if (debug) {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(2);
      rect(cx, cy, cw, ch);
    }
    popStyle();
  }

  // Dibuja el panel de bienestar / puntos / bloqueos y la barra inferior de avisos
  void dibujarHud() {
    float e = escalaFondo;
    pushStyle();
    rectMode(CORNER);
    textFont(fuente);

    // panel superior izquierdo: bienestar (de ModoJuego) + puntos y bloqueos
    dibujarPanelBienestar(175);
    float px = offsetX + 30 * e, py = offsetY + 30 * e;

    fill(255);
    text("PUNTOS  " + puntos + " / " + META_PUNTOS, px + 15 * e, py + 76 * e);
    text("BLOQUEOS  " + bloqueados + " / " + BLOQUEOS_PARA_REPORTE, px + 15 * e, py + 106 * e);
    if (bloqueados >= BLOQUEOS_PARA_REPORTE && (millis() / 400) % 2 == 0) {
      fill(255, 220, 120);
      text("[R] REPORTAR", px + 15 * e, py + 138 * e);
    }

    // barra inferior del monitor: controles y avisos
    float bx = offsetX + campoX * e, by = offsetY + (campoY + campoH + 14) * e, bw = campoW * e, bh = 64 * e;
    fill(10, 10, 30, 215);
    rect(bx, by, bw, bh, 10 * e);
    textAlign(CENTER, CENTER);
    textSize(18 * e);
    if (millis() < avisoHasta) {
      fill(255, 220, 120);
      text(aviso, bx + bw / 2, by + bh / 2);
    } else {
      fill(200, 210, 255);
      text("[B] Bloquear    [A] Aprobar    [R] Reportar", bx + bw / 2, by + bh / 2);
    }
    popStyle();
  }

  // Cartel grande "REPORTAR" cuando ya hay bloqueos suficientes, para que se entienda que toca pulsar [R]
  void dibujarAvisoReporte() {
    if (estado != JUGANDO || bloqueados < BLOQUEOS_PARA_REPORTE) return;
    float e = escalaFondo;
    float pulso = 1 + 0.06 * sin(millis() * 0.012);
    pushStyle();
    pushMatrix();
    translate(offsetX + 971 * e, offsetY + 85 * e);     // arriba de la ventana de mensajes
    scale(pulso);
    rectMode(CENTER);
    fill(20, 20, 60, 235);
    stroke((millis() / 300) % 2 == 0 ? color(255, 220, 120) : color(255, 90, 90));
    strokeWeight(6 * e);
    rect(0, 0, 820 * e, 120 * e, 20 * e);
    noStroke();
    textFont(fuente);
    textAlign(CENTER, CENTER);
    fill(255, 220, 120);
    textSize(76 * e);
    text("¡REPORTAR!", 0, -14 * e);
    fill(255);
    textSize(26 * e);
    text("Pulsa  [R]", 0, 38 * e);
    popMatrix();
    popStyle();
  }

  // Pantalla final de victoria o derrota (usa la plantilla de ModoJuego)
  void dibujarFin() {
    dibujarFin("¡TURNO COMPLETADO!", "IVANA NO AGUANTA MÁS", "Puntos: " + puntos,
      "Clic para elegir otro modo   ·   ENTER para reintentar   ·   ESC para volver al menú");
  }
}

// Fondo del modo 1: PrimerModo.jpg (o la variante comprada en la tienda: PrimerModo_2.jpg ...)
PGraphics crearFondoModo1(int variante) {
  return crearFondoVariante(new String[] {"PrimerModo"}, variante, false);
}
