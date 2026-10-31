// Pantalla de seleccion de modo de juego: hereda de Pantalla.
// Las 2 zonas de clic son invisibles (estan sobre las 2 ventanas de la imagen "Modo de juego.jpg").
class PantallaModosJuego extends Pantalla {
  // Zonas en coordenadas del canvas 1920x1080: {x, y, ancho, alto}
  float[][] zonas = {
    { 353, 218, 542, 588},   // 0: ventana izquierda -> Modo 1 (Flagged & Filtered)
    {1021, 218, 565, 588}    // 1: ventana derecha   -> Modo 3 (De-escalate!)
  };

  // A que pantalla lleva cada modo (indice en pantallas[]). -1 = todavia no hace nada.
  int[] destinosModo = {6, 7};      // 6 = instrucciones Modo 1, 7 = instrucciones Modo 3

  PantallaModosJuego() {
    super("MODOS", crearFondoModos(), 0);   // 0 botones: usamos las zonas de arriba
  }

  // Devuelve la zona (0 o 1) bajo el mouse, o -1 si no hay ninguna.
  // Convierte canvas -> ventana con offsetX/offsetY/escalaFondo (igual que los Boton).
  int zonaEncima() {
    for (int i = 0; i < zonas.length; i++) {
      float x = offsetX + zonas[i][0] * escalaFondo;
      float y = offsetY + zonas[i][1] * escalaFondo;
      float w = zonas[i][2] * escalaFondo;
      float h = zonas[i][3] * escalaFondo;
      if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) return i;
    }
    return -1;
  }

  void draw() {
    int z = zonaEncima();
    cursor(z >= 0 ? HAND : ARROW);

    pushStyle();
    rectMode(CORNER);
    noFill();
    for (int i = 0; i < zonas.length; i++) {
      boolean visible = (i == z) || debug;            // resalte suave al pasar el mouse (o todas con D)
      if (!visible) continue;
      if (debug) { stroke(255, 0, 0); strokeWeight(2); }
      else       { stroke(255, 255, 255, 200); strokeWeight(4); }
      rect(offsetX + zonas[i][0] * escalaFondo, offsetY + zonas[i][1] * escalaFondo,
           zonas[i][2] * escalaFondo, zonas[i][3] * escalaFondo, 6);
    }
    popStyle();
  }

  int click() {
    int z = zonaEncima();
    if (z >= 0) return destinosModo[z];   // -1 si ese modo aun no existe
    return -1;
  }
}

// Dibuja una imagen llenando un rectangulo (x, y, w, h) del PGraphics sin deformarla:
// recorta el sobrante centrado (como imagenCover, pero para una zona).
void imagenEnRect(PGraphics pg, PImage img, float x, float y, float w, float h) {
  float aspRect = w / h;
  float aspImg = (float) img.width / img.height;
  int sw, sh;
  if (aspImg > aspRect) { sh = img.height; sw = round(img.height * aspRect); }   // sobra ancho
  else                  { sw = img.width;  sh = round(img.width / aspRect); }    // sobra alto
  PImage recorte = img.get((img.width - sw) / 2, (img.height - sh) / 2, sw, sh);
  pg.imageMode(CORNER);
  pg.image(recorte, x, y, w, h);
}

// Fondo: Modo de juego.jpg + portadas de los dos modos + titulos
PGraphics crearFondoModos() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  pg.background(40, 30, 70);                      // por si falta la imagen
  PImage img = loadImage("Modo de juego.jpg");
  if (img != null) imagenCover(pg, img);

  // Las portadas van dentro del recuadro claro de cada ventana (coordenadas del canvas).
  // Si no calzan, ajusta px, py, pw, ph de cada una (la tecla D muestra las zonas de clic).

  // --- Modo 1: ventana izquierda ---
  float px = 373, py = 276, pw = 500, ph = 418;
  PImage portada = loadImage("PrimerModo.jpg");
  if (portada != null) imagenEnRect(pg, portada, px, py, pw, ph);
  tituloModo(pg, "FLAGGED & FILTERED", px + pw / 2, 750);

  // --- Modo 3: ventana derecha ---
  float p3x = 1042, p3y = 276, p3w = 523, p3h = 418;
  PImage portada3 = cargarImagenAlguna(new String[] {"fondo_modo3.jpg", "fondo_modo3.png", "Fondo_modo3.jpg", "Fondo_modo3.png"});
  if (portada3 != null) imagenEnRect(pg, portada3, p3x, p3y, p3w, p3h);
  tituloModo(pg, "DE-ESCALATE!", p3x + p3w / 2, 750);

  pg.endDraw();
  return pg;
}

// Titulo de un modo debajo de su portada: blanco con contorno oscuro (estilo Y2K)
void tituloModo(PGraphics pg, String titulo, float tx, float ty) {
  pg.textFont(fuente);
  pg.textSize(38);
  pg.textAlign(CENTER, CENTER);
  pg.fill(20, 20, 60);
  for (int dx = -3; dx <= 3; dx += 3) {
    for (int dy = -3; dy <= 3; dy += 3) {
      if (dx != 0 || dy != 0) pg.text(titulo, tx + dx, ty + dy);   // contorno
    }
  }
  pg.fill(255);
  pg.text(titulo, tx, ty);
}
