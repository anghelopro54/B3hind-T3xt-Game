// UIRetro - utilidades de dibujo compartidas por las pantallas nuevas.
// Todo se dibuja en coordenadas de la IMAGEN ORIGINAL (2356 x 1316), igual que Boton,
// y se convierte a pantalla con sx(), sy() y ss(), que usan escalaFondo/offsetX/offsetY.
// Asi cualquier cosa que se dibuje aqui mantiene la proporcion en pantalla completa.

final float REF_W = 2356;
final float REF_H = 1316;

// Paleta (estilo CRT / red social de los 2000)
final int COL_PANEL    = #121A3C;
final int COL_BORDE    = #8FB4FF;
final int COL_TEXTO    = #EAF2FF;
final int COL_TITULO   = #BCD4FF;
final int COL_ROSA     = #FF5FA2;
final int COL_VERDE    = #3DDC84;
final int COL_AMARILLO = #FFD84D;
final int COL_ROJO     = #FF4D5E;
final int COL_GRIS     = #9AA3B5;

PFont fuentePixel;

// Humores para dibujar caritas simples (sirven como respaldo si falta un PNG)
final int H_NEUTRAL = 0;
final int H_FELIZ   = 1;
final int H_ENOJADO = 2;
final int H_TRISTE  = 3;
final int H_SORPRESA = 4;

// Corazon en pixeles (7 x 6)
final int[][] PAT_CORAZON = {
  {0, 1, 1, 0, 1, 1, 0},
  {1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1},
  {0, 1, 1, 1, 1, 1, 0},
  {0, 0, 1, 1, 1, 0, 0},
  {0, 0, 0, 1, 0, 0, 0}
};

// Llamar una vez en setup()
// Si existe data/fuente.ttf se usa esa fuente (por ejemplo una pixel font con tildes);
// si no, se usa la monoespaciada del sistema.
void iniciarUI() {
  File f = new File(dataPath("fuente.ttf"));
  fuentePixel = f.exists() ? createFont("fuente.ttf", 96) : createFont("Monospaced.bold", 96);
}

// --- Conversion imagen original -> pantalla ---
float sx(float x) { return offsetX + x * escalaFondo; }
float sy(float y) { return offsetY + y * escalaFondo; }
float ss(float s) { return s * escalaFondo; }

float easeOut(float k) {
  k = constrain(k, 0, 1);
  return 1 - pow(1 - k, 3);
}

// --- Texto ---

// Texto con coordenadas y tamano en pixeles de PANTALLA (sirve dentro de pushMatrix)
void textoPx(String s, float x, float y, float tamPx, int col, int ah, int av) {
  if (fuentePixel == null) iniciarUI();
  textFont(fuentePixel);
  textAlign(ah, av);
  textSize(max(1, tamPx));
  fill(0, 150);
  text(s, x + tamPx * 0.05, y + tamPx * 0.06);   // sombra
  fill(col);
  text(s, x, y);
}

// Texto con coordenadas y tamano en pixeles de la IMAGEN ORIGINAL
void textoRetro(String s, float x, float y, float tam, int col, int ah, int av) {
  textoPx(s, sx(x), sy(y), ss(tam), col, ah, av);
}

// Tamano de texto (en px de pantalla) que hace caber s en anchoMax
float tamQueCabe(String s, float anchoMax, float tamMax) {
  if (fuentePixel == null) iniciarUI();
  textFont(fuentePixel);
  textSize(tamMax);
  float tw = textWidth(s);
  return (tw > anchoMax) ? tamMax * anchoMax / tw : tamMax;
}

// Cuantas lineas ocupa s si se parte por palabras en un ancho dado (px de pantalla).
// Hay que fijar antes textFont y textSize.
int lineasNecesarias(String s, float anchoPx) {
  String[] palabras = split(s, ' ');
  int lineas = 1;
  float acum = 0;
  float esp = textWidth(" ");
  for (String p : palabras) {
    float pw = textWidth(p);
    if (acum > 0 && acum + esp + pw > anchoPx) {
      lineas++;
      acum = pw;
    } else {
      acum += (acum > 0 ? esp : 0) + pw;
    }
  }
  return lineas;
}

// Tamano mas grande (entre tamMax y tamMin, px de pantalla) con el que el texto cabe en la caja
float tamAjustado(String s, float anchoPx, float altoPx, float tamMax, float tamMin) {
  if (fuentePixel == null) iniciarUI();
  textFont(fuentePixel);
  for (float t = tamMax; t > tamMin; t -= 2) {
    textSize(t);
    if (lineasNecesarias(s, anchoPx) * t * 1.25 <= altoPx) return t;
  }
  return tamMin;
}

// --- Formas ---

// Panel con sombra, borde y brillo interior
void panelRetro(float x, float y, float w, float h, int relleno, float alfa, int borde) {
  rectMode(CORNER);
  noStroke();
  fill(0, 110);
  rect(sx(x) + ss(8), sy(y) + ss(8), ss(w), ss(h), ss(12));
  fill(relleno, alfa);
  stroke(borde);
  strokeWeight(max(1.5, ss(4)));
  rect(sx(x), sy(y), ss(w), ss(h), ss(12));
  noFill();
  stroke(255, 55);
  strokeWeight(max(1, ss(2)));
  rect(sx(x) + ss(9), sy(y) + ss(9), ss(w) - ss(18), ss(h) - ss(18), ss(7));
  noStroke();
  strokeWeight(1);
}

// Corazon pixelado; (x, y) es la esquina superior izquierda, celda en px de la imagen original
void corazonPixel(float x, float y, float celda, int col, float alfa) {
  rectMode(CORNER);
  noStroke();
  for (int f = 0; f < PAT_CORAZON.length; f++) {
    for (int c = 0; c < PAT_CORAZON[f].length; c++) {
      if (PAT_CORAZON[f][c] == 1) {
        fill(col, alfa);
        rect(sx(x + c * celda), sy(y + f * celda), ss(celda) + 1, ss(celda) + 1);
      }
    }
  }
  fill(255, alfa * 0.7);   // brillito
  rect(sx(x + celda), sy(y + celda), ss(celda) + 1, ss(celda) + 1);
}

// Carita simple (cx, cy, r en px de pantalla)
void caritaRetro(float cx, float cy, float r, int humor, int col) {
  ellipseMode(CENTER);
  stroke(0, 170);
  strokeWeight(max(1, r * 0.08));
  fill(col);
  ellipse(cx, cy, r * 2, r * 2);

  noStroke();
  fill(30, 20, 40);
  float ey = cy - r * 0.18;
  if (humor == H_SORPRESA) {
    fill(255);
    ellipse(cx - r * 0.35, ey, r * 0.42, r * 0.5);
    ellipse(cx + r * 0.35, ey, r * 0.42, r * 0.5);
    fill(30, 20, 40);
    ellipse(cx - r * 0.35, ey, r * 0.18, r * 0.2);
    ellipse(cx + r * 0.35, ey, r * 0.18, r * 0.2);
  } else {
    ellipse(cx - r * 0.35, ey, r * 0.2, r * 0.26);
    ellipse(cx + r * 0.35, ey, r * 0.2, r * 0.26);
  }

  noFill();
  stroke(30, 20, 40);
  strokeWeight(max(1, r * 0.12));
  strokeCap(ROUND);
  if (humor == H_FELIZ) {
    arc(cx, cy + r * 0.05, r * 1.0, r * 0.7, 0.2, PI - 0.2);
  } else if (humor == H_ENOJADO) {
    arc(cx, cy + r * 0.62, r * 0.9, r * 0.55, PI + 0.3, TWO_PI - 0.3);
    line(cx - r * 0.6, ey - r * 0.38, cx - r * 0.15, ey - r * 0.18);   // cejas
    line(cx + r * 0.6, ey - r * 0.38, cx + r * 0.15, ey - r * 0.18);
  } else if (humor == H_TRISTE) {
    arc(cx, cy + r * 0.6, r * 0.8, r * 0.5, PI + 0.3, TWO_PI - 0.3);
    line(cx - r * 0.6, ey - r * 0.15, cx - r * 0.15, ey - r * 0.38);
    line(cx + r * 0.6, ey - r * 0.15, cx + r * 0.15, ey - r * 0.38);
  } else if (humor == H_SORPRESA) {
    fill(30, 20, 40);
    ellipse(cx, cy + r * 0.45, r * 0.4, r * 0.5);
  } else {
    line(cx - r * 0.3, cy + r * 0.45, cx + r * 0.3, cy + r * 0.45);
  }
  strokeWeight(1);
  noStroke();
}

// --- Fondos ---

// Fondo retro generado por codigo (degradado + cuadricula + estrellas + scanlines).
// Sirve mientras no haya arte propio; ver fondoOpcional().
PImage crearFondoRetro(int w, int h, int cArriba, int cAbajo, boolean escritorio) {
  PGraphics pg = createGraphics(w, h);
  pg.beginDraw();
  for (int y = 0; y < h; y++) {
    pg.stroke(lerpColor(cArriba, cAbajo, y / (float) h));
    pg.line(0, y, w, y);
  }
  pg.stroke(255, 255, 255, 16);
  pg.strokeWeight(2);
  for (int x = 0; x <= w; x += 118) pg.line(x, 0, x, h);
  for (int y = 0; y <= h; y += 118) pg.line(0, y, w, y);

  randomSeed(7);
  pg.noStroke();
  for (int i = 0; i < 160; i++) {
    int t = (random(1) < 0.25) ? 8 : 4;
    pg.fill(255, random(50, 190));
    pg.rect(int(random(w)), int(random(h)), t, t);
  }
  if (escritorio) dibujarEscritorio(pg, w, h);
  pg.stroke(0, 34);
  pg.strokeWeight(2);
  for (int y = 0; y < h; y += 6) pg.line(0, y, w, y);
  pg.endDraw();
  return pg.get();
}

// Escritorio con teclado RGB y mousepad en la parte baja (relleno mientras no haya arte)
void dibujarEscritorio(PGraphics pg, int w, int h) {
  float yMesa = h * 0.76;
  pg.noStroke();
  pg.fill(24, 16, 52);
  pg.rect(0, yMesa, w, h - yMesa);
  pg.fill(110, 120, 220, 90);
  pg.rect(0, yMesa, w, 6);

  // mousepad y mouse
  pg.fill(40, 30, 90);
  pg.rect(1700, yMesa + 60, 360, 210, 26);
  pg.fill(200, 205, 235);
  pg.ellipse(1880, yMesa + 170, 90, 120);
  pg.fill(70, 80, 160);
  pg.ellipse(1880, yMesa + 148, 40, 40);

  // teclado con luces de colores
  float kx = 760, ky = yMesa + 44, kw = 52, kh = 40, gap = 9;
  pg.fill(14, 10, 34);
  pg.rect(kx - 22, ky - 22, 14 * (kw + gap) + 30, 5 * (kh + gap) + 28, 16);
  pg.colorMode(HSB, 360, 100, 100);
  for (int f = 0; f < 5; f++) {
    for (int c = 0; c < 14; c++) {
      pg.fill((c * 22 + f * 30) % 360, 55, 85, 70);
      pg.rect(kx + c * (kw + gap), ky + f * (kh + gap), kw, kh, 6);
    }
  }
  pg.colorMode(RGB, 255);
}

// Si existe data/<archivo> lo usa (reescalado a 2356 x 1316); si no, usa el de por defecto.
// Asi el equipo puede soltar "juego.png" o "creditos.png" en data/ sin tocar el codigo.
PImage fondoOpcional(String archivo, PImage porDefecto) {
  File f = new File(dataPath(archivo));
  if (f.exists()) {
    PImage img = loadImage(archivo);
    if (img != null) {
      img.resize((int) REF_W, (int) REF_H);
      return img;
    }
  }
  return porDefecto;
}
