// =====================================================================================
// UTILIDADES: funciones de ayuda que usan varias pantallas (imagenes, fondos y texto).
// =====================================================================================

// ---------------------------------------------------------------------------------
// IMAGENES
// ---------------------------------------------------------------------------------

// Carga la primera imagen que exista en data (sin llenar la consola de errores). null si no hay ninguna.
PImage cargarImagenAlguna(String[] nombres) {
  for (String n : nombres) {
    if (new File(dataPath(n)).exists()) return loadImage(n);
  }
  return null;
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

// Devuelve una copia de la imagen escalada para que quepa en la ventana sin deformarse
PImage escalarPantalla(PImage img) {
  float esc = min((float) width / img.width, (float) height / img.height);
  PImage copia = img.get();
  copia.resize(round(img.width * esc), round(img.height * esc));
  return copia;
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

  float br = red(px[0]), bgr = green(px[0]), bb = blue(px[0]);   // color del fondo (la esquina)
  boolean[] visto = new boolean[w * h];                           // pixeles ya marcados como fondo
  int[] pila = new int[w * h];                                    // pila para el relleno por inundacion
  int n = 0;

  // semillas: todos los pixeles de los 4 bordes que se parezcan al fondo
  for (int k = 0; k < w + h; k++) {
    int[] borde = (k < w) ? new int[] {k, (h - 1) * w + k}                        // arriba y abajo
                          : new int[] {(k - w) * w, (k - w) * w + w - 1};         // izquierda y derecha
    for (int p : borde) {
      if (!visto[p] && parecidoA(px[p], br, bgr, bb)) {
        visto[p] = true;
        pila[n++] = p;
      }
    }
  }

  // relleno por inundacion hacia adentro (revisa los 4 vecinos de cada pixel)
  while (n > 0) {
    int i = pila[--n];
    int x = i % w, y = i / w;
    int[] vecinos = {
      (x > 0)     ? i - 1 : -1,
      (x < w - 1) ? i + 1 : -1,
      (y > 0)     ? i - w : -1,
      (y < h - 1) ? i + w : -1
    };
    for (int v : vecinos) {
      if (v >= 0 && !visto[v] && parecidoA(px[v], br, bgr, bb)) {
        visto[v] = true;
        pila[n++] = v;
      }
    }
  }

  // lo marcado como fondo queda transparente (0); el resto se vuelve opaco
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

// ---------------------------------------------------------------------------------
// FONDOS CON VARIANTES (los que se compran en la tienda)
// ---------------------------------------------------------------------------------

// Tintes que se usan cuando NO existe una imagen propia para esa variante (una por cada fondo de la tienda)
final int[][] TINTES = {{255, 255, 255}, {150, 170, 255}, {255, 170, 200}, {255, 190, 120}, {150, 255, 170}};

// Fondo a pantalla completa de un modo. 'bases' son los posibles nombres del archivo (sin extension).
//   variante 0 -> imagen original (ej. PrimerModo.jpg)
//   variante 1, 2, ... -> PrimerModo_2.jpg, PrimerModo_3.jpg ...; si ese archivo no existe se usa la
//   original con un tinte de color (ver TINTES), asi la tienda funciona aunque no tengas las imagenes.
// monitorRespaldo: si no hay ninguna imagen, dibuja un rectangulo negro donde va la pantalla del monitor.
PGraphics crearFondoVariante(String[] bases, int variante, boolean monitorRespaldo) {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  pg.background(40, 30, 70);                                   // por si falta la imagen
  String sufijo = (variante == 0) ? "" : "_" + (variante + 1);

  PImage img = cargarImagenAlguna(nombresImagen(bases, sufijo));
  if (img == null && variante > 0) {                           // aun no hay imagen propia: la original con otro tinte
    img = cargarImagenAlguna(nombresImagen(bases, ""));
    int[] t = TINTES[variante % TINTES.length];
    pg.tint(t[0], t[1], t[2]);
  }
  if (img != null) {
    imagenCover(pg, img);
  } else if (monitorRespaldo) {
    pg.noStroke();
    pg.fill(0);
    pg.rect(625, 225, 682, 492, 30);
  }
  pg.noTint();
  pg.endDraw();
  return pg;
}

// Todas las combinaciones nombre + sufijo + extension (.jpg y .png)
String[] nombresImagen(String[] bases, String sufijo) {
  String[] res = new String[bases.length * 2];
  for (int i = 0; i < bases.length; i++) {
    res[2 * i] = bases[i] + sufijo + ".jpg";
    res[2 * i + 1] = bases[i] + sufijo + ".png";
  }
  return res;
}

// ---------------------------------------------------------------------------------
// TEXTO
// ---------------------------------------------------------------------------------

// Cuantas lineas ocupa un texto en una caja de ese ancho, con el textFont / textSize que tenga 'pg'.
// (para el lienzo principal se pasa 'g'; para un PGraphics propio, ese PGraphics)
int contarLineas(PGraphics pg, String s, float ancho) {
  String[] palabras = split(s, " ");
  int lineas = 1;
  String actual = "";
  for (String p : palabras) {
    String prueba = actual.length() == 0 ? p : actual + " " + p;
    if (pg.textWidth(prueba) <= ancho) actual = prueba;
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
    if (contarLineas(g, s, ancho * 0.96) * sz * 1.25 <= alto) break;
    sz -= 1;
  }
  popStyle();
  return sz;
}
