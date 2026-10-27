// B3hind T3xt - Menu principal
// Los botones se definen en coordenadas de la IMAGEN ORIGINAL (2356 x 1316),
// asi funcionan en cualquier resolucion de pantalla.

PImage fondo;
Pantalla[] pantallas;    // 0 = MENU, 1 = JUEGO, 2 = CONFIGURACION, 3 = CREDITOS
int actual = 0;          // posicion en la lista de la pantalla que se esta mostrando
final int SALIR = -2;    // destino especial: cerrar el programa
EfectoTv tv;             // variable global para efecto de tv antiguo
PFont fuente;

boolean debug = false;   // tecla D para ver los rectangulos rojos

// Posicion y escala con la que se dibuja el fondo (se recalculan en calcularLayout)
float escalaFondo = 1;
float offsetX = 0;
float offsetY = 0;

// fullScreen() debe ir en settings(), no en setup()
void settings() {
  fullScreen();
  pixelDensity(1);
}

void setup() {
  fuente = createFont("pixel.ttf", 48);
  fondo = loadImage("home.jpg");

  // Todas las pantallas se crean aqui, antes de usarlas (si no, error de null)
  pantallas = new Pantalla[5];

  // MENU: nombre, imagen, cantidad de botones
  pantallas[0] = new Pantalla("MENU", fondo, 4);
  // nombre, x, y, ancho, alto (pixeles de la imagen original) y a que pantalla lleva
  pantallas[0].Ponerboton(0, new Boton("JUGAR",         1176,  768, 424, 100, fondo), 4);
  pantallas[0].Ponerboton(1, new Boton("CONFIGURACION", 1128,  888, 520,  96, fondo), 2);
  pantallas[0].Ponerboton(2, new Boton("CREDITOS",      1176, 1000, 424, 100, fondo), 3);
  pantallas[0].Ponerboton(3, new Boton("SALIR",         1176, 1116, 424,  96, fondo), SALIR);

  // Las demas pantallas, por ahora sin botones (se vuelve al menu con ESC)
  pantallas[1] = new PantallaJuego();
  pantallas[2] =  new PantallaConfiguracion();
  pantallas[3] = new PantallaCreditos();
 pantallas[4] = new PantallaModosJuego();
 
  tv = new EfectoTv();

  calcularLayout();
}

void draw() {
  background(0);
  calcularLayout();

  // Fondo (sin deformar, centrado)
  PImage f = pantallas[actual].fondoEsc;
  imageMode(CORNER);
  int dy = round(sin(frameCount * 0.05) * 1.5);
  image(f, offsetX, offsetY + dy);

  // Animaciones, botones y cursor de la pantalla actual
  pantallas[actual].draw();


  if (debug) {
    rectMode(CORNER);
    stroke(255, 0, 0);
    noFill();
    strokeWeight(2);
    for (Boton b : pantallas[actual].botones) {
      rect(b.pantallaX(), b.pantallaY(), b.pantallaW(), b.pantallaH());
    }
  }
  tv.dibujar();
  println(frameRate);

  if (debug) {
  pushStyle();
  fill(255, 255, 0);
  textAlign(LEFT, TOP);
  textSize(24);
  float imgX = (mouseX - offsetX) / escalaFondo;
  float imgY = (mouseY - offsetY) / escalaFondo;
  text("Ventana: " + mouseX + ", " + mouseY, 20, 20);
  text("Imagen:  " + int(imgX) + ", " + int(imgY), 20, 50);
  popStyle();
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
    pantallas[actual].reiniciar();
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
