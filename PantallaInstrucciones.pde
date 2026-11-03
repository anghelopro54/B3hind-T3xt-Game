// =====================================================================================
// Instrucciones de un modo: titulo + parrafos escritos sobre Instrucciones.jpg, con botones Jugar y Volver.
// Se reutiliza para los dos modos; destinoJugar = pantalla a la que lleva el boton Jugar.
// =====================================================================================
class PantallaInstrucciones extends Pantalla {
  PantallaInstrucciones(String titulo, String[] parrafos, int destinoJugar) {
    super("INSTRUCCIONES", crearFondoInstrucciones(titulo, parrafos), 2);
    Ponerboton(0, new Boton("Jugar", 830, 815, 260, 70, fondo), destinoJugar);
    Ponerboton(1, new Boton("Volver", 1700, 43, 200, 65, fondo), P_MODOS);   // vuelve a la eleccion de modos
  }
}


// Arma la imagen: fondo, texto con saltos de linea calculados y los dos botones dibujados
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
  // botones (su posicion debe coincidir con los Boton de arriba): Jugar debajo de la ventana, Volver arriba a la derecha
  dibujarBotonXP(pg, "Jugar", 830, 815, 260, 70);
  dibujarBotonXP(pg, "Volver", 1700, 43, 200, 65);

  pg.endDraw();
  return pg;
}
