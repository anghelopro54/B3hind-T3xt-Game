// B3hind T3xt - Menu principal
// Los botones se definen en coordenadas de la IMAGEN ORIGINAL (2754 x 1536),
// asi funcionan en cualquier resolucion de pantalla.

PImage fondo;
Boton[] botones;     // 0 = JUGAR, 1 = CONFIGURACION, 2 = CREDITOS, 3 = SALIR

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
  calcularLayout();

  // nombre, x, y, ancho, alto (pixeles de la imagen original)
  botones = new Boton[4];
  botones[0] = new Boton("JUGAR",         1395,  985, 492, 135, fondo);
  botones[1] = new Boton("CONFIGURACION", 1302, 1158, 678, 134, fondo);
  botones[2] = new Boton("CREDITOS",      1389, 1323, 496, 100, fondo);
  botones[3] = new Boton("SALIR",         1389, 1455, 496,  81, fondo);  // en la imagen esta cortado por el borde inferior
}

void draw() {
  background(0);
  calcularLayout();

  // Fondo (sin deformar, centrado)
  imageMode(CORNER);
  image(fondo, offsetX, offsetY, fondo.width * escalaFondo, fondo.height * escalaFondo);

  // Actualizar animaciones y detectar si el mouse esta sobre algun boton
  boolean encima = false;
  for (Boton b : botones) {
    b.actualizar(mouseX, mouseY);
    if (b.estaEncima(mouseX, mouseY)) encima = true;
  }

  // Dibujar botones
  for (Boton b : botones) {
    b.dibujar();
  }

  cursor(encima ? HAND : ARROW);

  if (debug) {
    rectMode(CORNER);
    stroke(255, 0, 0);
    noFill();
    strokeWeight(2);
    for (Boton b : botones) {
      rect(b.pantallaX(), b.pantallaY(), b.pantallaW(), b.pantallaH());
    }
  }
}

// Escala la imagen para que quepa en la pantalla manteniendo proporcion
void calcularLayout() {
  escalaFondo = min((float) width / fondo.width, (float) height / fondo.height);
  offsetX = (width  - fondo.width  * escalaFondo) / 2;
  offsetY = (height - fondo.height * escalaFondo) / 2;
}

void mousePressed() {
  for (int i = 0; i < botones.length; i++) {
    if (botones[i].estaEncima(mouseX, mouseY)) {
      botones[i].presionar();
      accionBoton(i);
    }
  }
}

void accionBoton(int i) {
  switch (i) {
    case 0:
      println("JUGAR");
      // TODO: cambiar a la pantalla de juego
      break;
    case 1:
      println("CONFIGURACION");
      // TODO: cambiar a la pantalla de configuracion
      break;
    case 2:
      println("CREDITOS");
      // TODO: cambiar a la pantalla de creditos
      break;
    case 3:
      exit();
      break;
  }
}

void keyPressed() {
  if (key == 'd' || key == 'D') debug = !debug;
}
