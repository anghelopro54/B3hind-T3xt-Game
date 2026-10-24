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
    escen[0] = escalarPantalla(crearEscenaHabitacion());
    escen[1] = escalarPantalla(crearEscenaEmail());
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
    fill(255);

    // cuerpo del email (se escribe en la linea del email, y queda fijo en las siguientes de esa escena)
    if (escena[linea] == 1) {
      textSize(34 * escalaFondo);
      String cuerpo = emisor[linea].equals("EMAIL") ? t : texto[lineaEmail];
      text(cuerpo, offsetX + 340 * escalaFondo, offsetY + 330 * escalaFondo, 1240 * escalaFondo, 610 * escalaFondo);
    }

    // caja de dialogo: no se usa en la linea del email
    if (!emisor[linea].equals("EMAIL")) {
      noStroke();
      fill(20, 20, 60, 220);
      rect(width * 0.1, height * 0.7, width * 0.8, height * 0.25, 20);

      fill(255, 220, 120);
      textSize(32);
      text(emisor[linea], width * 0.12, height * 0.72);

      fill(255);
      textSize(30);
      text(t, width * 0.12, height * 0.78, width * 0.76, height * 0.15);
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
PGraphics crearEscenaEmail() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  ventanaxp(pg, "Outlook", 380, false);

  pg.textFont(fuente);
  pg.fill(255);
  pg.textAlign(LEFT, TOP);
  pg.textSize(34);
  pg.text("De: Confianza y Seguridad", 340, 130);
  pg.text("Para: Ivana Rios", 340, 180);
  pg.text("Asunto: URGENTE - Aumento de comentarios toxicos", 340, 230);

  pg.stroke(255);
  pg.strokeWeight(3);
  pg.line(340, 295, 1580, 295);
  pg.endDraw();

  return pg;
}

PGraphics crearEscenaHabitacion() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  pg.background(60, 50, 110);
  pg.endDraw();

  return pg;
}
