class PantallaInstrucciones extends Pantalla {
  PantallaInstrucciones(String titulo, String[] parrafos, int destinoJugar) {
    super("INSTRUCCIONES", crearFondoInstrucciones(titulo, parrafos), 1);
    Ponerboton(0, new Boton("Jugar", 830, 815, 260, 70, fondo), destinoJugar);
  }
}


int contarLineas(PGraphics pg, String s, float ancho) {
  String[] palabras = split(s, " ");
  int lineas = 1;
  String actual = "";
  for (String p : palabras) {
    String prueba = actual.length() == 0 ? p : actual + " " + p;
    if (pg.textWidth(prueba) <= ancho) actual = prueba;
    else {
      lineas ++;
      actual = p;
    }
  }
  return lineas;
}

PGraphics crearFondoInstrucciones(String titulo, String[] parrafos) {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  pg.background(40, 30, 70);                          // por si falta la imagen
  PImage img = loadImage("Instrucciones.jpg");        // <-- nombre real de tu imagen
  if (img != null) imagenCover(pg, img);

  // area crema de la ventana: x 624-1262, y 375-745
  float x = 624, ancho = 638, y = 375;
  pg.textFont(fuente);
  pg.rectMode(CORNER);
  pg.textAlign(LEFT, TOP);
  pg.textLeading(32);

  pg.fill(90, 40, 150);
  pg.textSize(28);
  pg.text(titulo, x, y, ancho, 40);
  y += 50;

  pg.fill(20, 20, 60);
  pg.textSize(24);
  for (String p : parrafos) {
    int n = contarLineas(pg, p, ancho);
    pg.text(p, x, y, ancho, n * 32 + 8);
    y += n * 32 + 12;                                 // el siguiente parrafo va debajo
  }
  // boton Jugar (debajo de la ventana), mismo estilo que Volver
  pg.fill(150, 179, 230);
  pg.stroke(20, 20, 60);
  pg.strokeWeight(6);
  pg.rect(830, 815, 260, 70, 20);
  pg.fill(20, 20, 60);
  pg.textAlign(CENTER, CENTER);
  pg.textSize(37);
  pg.text("Jugar", 960, 850);

  pg.endDraw();
  return pg;
}
