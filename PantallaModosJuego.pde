// Pantalla de seleccion de modo de juego: hereda de Pantalla.
// Las 3 zonas de clic son invisibles (estan sobre las 3 ventanas de la imagen).
class PantallaModosJuego extends Pantalla {
  // Zonas en coordenadas del canvas 1920x1080: {x, y, ancho, alto}
  float[][] zonas = {
    { 260, 221, 456, 588},   // 0: ventana izquierda -> Primer modo
    { 746, 205, 452, 654},   // 1: ventana central   -> Segundo modo
    {1232, 217, 454, 592}    // 2: ventana derecha   -> Tercer modo
  };

  // A que pantalla lleva cada modo (indice en pantallas[]). -1 = todavia no hace nada.
  // Cuando crees las pantallas de los otros modos, cambia el -1 por su indice.
  int[] destinosModo = {1, -1, -1};

  PantallaModosJuego() {
    super("MODOS", crearFondoModos(), 0);   // 0 botones: usamos las zonas de arriba
  }

  // Devuelve la zona (0, 1 o 2) bajo el mouse, o -1 si no hay ninguna.
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

// Fondo: Modo de juego.jpg + portada del primer modo + titulo
PGraphics crearFondoModos() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  pg.background(40, 30, 70);                      // por si falta la imagen
  PImage img = loadImage("Modo de juego.jpg");
  if (img != null) imagenCover(pg, img);

  // --- Primer modo: portada dentro del cuadrado blanco de la ventana izquierda ---
  float px = 277, py = 272, pw = 427, ph = 372;
  PImage portada = loadImage("PrimerModo.jpg");
  if (portada != null) imagenEnRect(pg, portada, px, py, pw, ph);

  // titulo debajo de la portada: blanco con contorno oscuro (estilo Y2K)
  String titulo = "FLAGGED & FILTERED";
  float tx = px + pw / 2, ty = 700;
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

  pg.endDraw();
  return pg;
}
