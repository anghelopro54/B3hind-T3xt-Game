class PantallaJuego extends Pantalla {
  String[] emisor = {"NARRADOR", "NARRADOR", "IVANA", "EMAIL", "IVANA", "NARRADOR"};
  String[] texto = {
  /* 0 */    "Ivana Ríos, 24 años. Agente de ciberseguridad en Vinculo, la red social donde todos están siempre conectados.",
  /* 1 */    "Su oficina es el escritorio de su cuarto, y su equipo, una pantalla que nunca se apaga.",
  /* 2 */    "Otro martes tranquilo... ojalá.",
  /* 3 */    "Hola, Ivana: en las últimas 48 horas los reportes por acoso y mensajes de odio se triplicaron. Te asignamos una cola de cuentas con conducta sospechosa. Revisa cada perfil y decide: ADVERTIR, BANEAR o APROBAR si cumple las normas. Recuerda: detrás de cada cuenta hay una persona. Equipo de Confianza y Seguridad.",
  /* 4 */    "¿Triplicaron? Bien, manos a la obra.",
  /* 5 */    "Cada decisión cuenta. Think B4 U send."
  };
  int[] escena = {0, 0, 0, 1, 1, 0};
  PImage[] escen;
  int linea = 0;
  int iniciolinea;
  int lineaEmail = 3;
  boolean cinematica = true;

  PantallaJuego() {
    super("JUEGO", crearFondoJuego(), 0);

    escen = new PImage[2];
    escen[0] = escalarPantalla(crearEscenaHabitacion());   // webcam (storytelling)
    escen[1] = escalarPantalla(crearEscenaEmail());        // correo Y2K
  }

  void reiniciar() {
    linea = 0;
    iniciolinea = millis();
    cinematica = true;
  }

  void draw() {
    if (cinematica) dibujarCinematica();
    else super.draw();
  }

  int click() {
    if (cinematica) {
      avanzar();
      return -1;
    }
    return super.click();
  }

  void dibujarCinematica() {
    image(escen[escena[linea]], offsetX, offsetY);

    int visible = int((millis() - iniciolinea) * 0.03);
    String t = texto[linea].substring(0, min(visible, texto[linea].length()));

    pushStyle();
    textFont(fuente);
    textAlign(LEFT, TOP);
    rectMode(CORNER);

    // cuerpo del email (se escribe en la linea del email, y queda fijo en las siguientes de esa escena)
    // coordenadas del canvas 1920x1080, convertidas con escalaFondo/offset
    if (escena[linea] == 1) {
      fill(20, 20, 50);                                  // texto oscuro sobre el panel blanco
      textSize(28 * escalaFondo);
      textLeading(34 * escalaFondo);
      String cuerpo = emisor[linea].equals("EMAIL") ? t : texto[lineaEmail];
      text(cuerpo, offsetX + 659 * escalaFondo, offsetY + 579 * escalaFondo, 759 * escalaFondo, 200 * escalaFondo);
    }

    // caja de dialogo (abajo, para no tapar el correo): no se usa en la linea del email
    if (!emisor[linea].equals("EMAIL")) {
      noStroke();
      fill(20, 20, 60, 220);
      rect(width * 0.1, height * 0.76, width * 0.8, height * 0.2, 20);

      fill(255, 220, 120);
      textSize(32);
      text(emisor[linea], width * 0.12, height * 0.78);

      fill(255);
      textSize(30);
      text(t, width * 0.12, height * 0.84, width * 0.76, height * 0.11);
    }
    popStyle();
  }

  void avanzar() {
    int visible = int((millis() - iniciolinea) * 0.03);

    if (visible < texto[linea].length()) {
      iniciolinea = millis() - 100000;
    } else if (linea < texto.length - 1) {
      linea++;
      iniciolinea = millis();
    } else {
      cinematica = false;
    }
  }
}

PGraphics crearFondoJuego() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  pg.textFont(fuente);
  pg.background(20, 20, 40);

  pg.fill(255);
  pg.textAlign(CENTER, CENTER);
  pg.textSize(60);
  pg.text("JUEGO", pg.width / 2, pg.height / 2);

  pg.endDraw();

  return pg;
}

// Dibuja una imagen en un PGraphics 1920x1080 llenando TODO el canvas (modo "cover"):
// escala uniforme y recorta el sobrante centrado, sin deformar.
void imagenCover(PGraphics pg, PImage img) {
  float s = max((float) pg.width / img.width, (float) pg.height / img.height);
  float w = img.width * s;
  float h = img.height * s;
  pg.imageMode(CORNER);
  pg.image(img, (pg.width - w) / 2, (pg.height - h) / 2, w, h);
}

// Fondo del correo: Mail Background.jpg + parches que tapan el texto de ejemplo + texto propio
PGraphics crearEscenaEmail() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  pg.background(40, 30, 70);                       // por si falta la imagen
  PImage img = loadImage("Mail Background.jpg");
  if (img != null) imagenCover(pg, img);

  // parches (x0, y0, x1, y1) en coordenadas del canvas, con el color plano de cada zona
  pg.noStroke();
  pg.rectMode(CORNERS);
  pg.fill(188, 189, 222);                          // cabecera lavanda
  pg.rect(645, 411, 1348, 503);
  pg.rect(645, 506, 1441, 551);
  pg.fill(245, 252, 252);                          // cuerpo blanco
  pg.rect(645, 568, 1506, 745);
  pg.rect(645, 745, 1418, 782);
  pg.fill(244, 251, 251);                          // filas de la bandeja
  pg.rect(755, 315, 1517, 345);
  pg.rect(755, 350, 1517, 378);
  pg.rectMode(CORNER);

  pg.textFont(fuente);
  pg.fill(20, 20, 50);
  pg.textAlign(LEFT, CENTER);
  pg.textSize(30);
  pg.text("De: Confianza y Seguridad", 652, 432);
  pg.text("Para: Ivana Rios", 652, 479);
  pg.text("Asunto: URGENTE - Aumento de comentarios toxicos", 652, 527);
  pg.textSize(28);
  pg.text("URGENTE - Aumento de comentarios toxicos", 788, 330);
  pg.text("Bienvenida a Vinculo - Equipo de Confianza", 788, 364);
  pg.endDraw();

  return pg;
}

// Fondo del storytelling: Web Cam View.jpg a pantalla completa
PGraphics crearEscenaHabitacion() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  pg.background(60, 50, 110);                      // por si falta la imagen
  PImage img = loadImage("Web Cam View.jpg");
  if (img != null) imagenCover(pg, img);
  pg.endDraw();

  return pg;
}
