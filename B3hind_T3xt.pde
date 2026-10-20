// B3hind T3xt - Menu principal
// Los botones se definen en coordenadas de la IMAGEN ORIGINAL (2356 x 1316),
// asi funcionan en cualquier resolucion de pantalla.

PImage fondo;
Pantalla[] pantallas;    // 0 = MENU, 1 = JUEGO, 2 = CONFIGURACION, 3 = CREDITOS
int actual = 0;          // posicion en la lista de la pantalla que se esta mostrando
final int SALIR = -2;    // destino especial: cerrar el programa

boolean debug = false;   // tecla D para ver los rectangulos rojos

// Posicion y escala con la que se dibuja el fondo (se recalculan en calcularLayout)
float escalaFondo = 1;
float offsetX = 0;
float offsetY = 0;

// fullScreen() debe ir en settings(), no en setup()
void settings() {
  fullScreen();
}

void setup() {
  fondo = loadImage("home.jpg");

  // Todas las pantallas se crean aqui, antes de usarlas (si no, error de null)
  pantallas = new Pantalla[4];

  // MENU: nombre, imagen, cantidad de botones
  pantallas[0] = new Pantalla("MENU", fondo, 4);
  // nombre, x, y, ancho, alto (pixeles de la imagen original) y a que pantalla lleva
  pantallas[0].Ponerboton(0, new Boton("JUGAR",         1176,  768, 424, 100, fondo), 1);
  pantallas[0].Ponerboton(1, new Boton("CONFIGURACION", 1128,  888, 520,  96, fondo), 2);
  pantallas[0].Ponerboton(2, new Boton("CREDITOS",      1176, 1000, 424, 100, fondo), 3);
  pantallas[0].Ponerboton(3, new Boton("SALIR",         1176, 1116, 424,  96, fondo), SALIR);

  // Las demas pantallas, por ahora sin botones (se vuelve al menu con ESC)
  pantallas[1] = new Pantalla("JUEGO", fondo, 0);
  pantallas[2] = new Pantalla("CONFIGURACION", fondo, 0);
  pantallas[3] = new Pantalla("CREDITOS", fondo, 0);

  calcularLayout();
}

void draw() {
  background(0);
  calcularLayout();

  // Fondo (sin deformar, centrado)
  PImage f = pantallas[actual].fondo;
  imageMode(CORNER);
  image(f, offsetX, offsetY, f.width * escalaFondo, f.height * escalaFondo);

  // Animaciones, botones y cursor de la pantalla actual
  pantallas[actual].draw();

  // TEMPORAL: mientras las otras pantallas no tengan su propio diseno, se muestra su nombre
  if (actual != 0) {
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(80);
    text(pantallas[actual].nombre, width / 2, height / 2);
  }

  if (debug) {
    rectMode(CORNER);
    stroke(255, 0, 0);
    noFill();
    strokeWeight(2);
    for (Boton b : pantallas[actual].botones) {
      rect(b.pantallaX(), b.pantallaY(), b.pantallaW(), b.pantallaH());
    }
  }
}

// Escala la imagen para que quepa en la pantalla manteniendo proporcion
void calcularLayout() {
  PImage f = pantallas[actual].fondo;
  escalaFondo = min((float) width / f.width, (float) height / f.height);
  offsetX = (width  - f.width  * escalaFondo) / 2;
  offsetY = (height - f.height * escalaFondo) / 2;
}

void mousePressed() {
  int destino = pantallas[actual].click();   // -1 si no se hizo click en ningun boton
  if (destino == SALIR) {
    exit();
  } else if (destino >= 0) {
    actual = destino;
  }
}

void keyPressed() {
  if (key == 'd' || key == 'D') debug = !debug;

  // ESC vuelve al menu desde cualquier otra pantalla (key = 0 evita que cierre el programa)
  if (key == ESC && actual != 0) {
    actual = 0;
    key = 0;
  }
}
