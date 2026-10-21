// B3hind T3xt - Menu principal
// Los botones se definen en coordenadas de la IMAGEN ORIGINAL (2356 x 1316),
// asi funcionan en cualquier resolucion de pantalla.

PImage fondo;
Pantalla[] pantallas;    // 0 = MENU, 1 = JUEGO, 2 = CONFIGURACION, 3 = CREDITOS, 4 = GAMEOVER
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
  pantallas = new Pantalla[5];

  // MENU: nombre, imagen, cantidad de botones
  pantallas[0] = new Pantalla("MENU", fondo, 4);
  // nombre, x, y, ancho, alto (pixeles de la imagen original) y a que pantalla lleva
  pantallas[0].Ponerboton(0, new Boton("JUGAR",          520,  455, 320,  48, fondo), 1);
  pantallas[0].Ponerboton(1, new Boton("CRÉDITOS",       520,  535, 320,  48, fondo), 3);
  pantallas[0].Ponerboton(2, new Boton("CONFIGURACIÓN",  520,  615, 320,  48, fondo), 2);
  pantallas[0].Ponerboton(3, new Boton("SALIR",          520,  695, 320,  48, fondo), SALIR);
  
  // Utilidades de dibujo (fuente) y avatar compartido por las pantallas nuevas
  iniciarUI();
  AvatarView avatar = new AvatarView();

  // Fondos de JUEGO, CREDITOS y GAMEOVER
  PImage fondoJuego    = fondoOpcional("juego.png",    crearFondoRetro((int) REF_W, (int) REF_H, #1B1445, #0C1633, true));
  PImage fondoCreditos = fondoOpcional("creditos.png", crearFondoRetro((int) REF_W, (int) REF_H, #2A1457, #101B45, false));
  PImage fondoGameOver = fondoOpcional("gameover.png", crearFondoRetro((int) REF_W, (int) REF_H, #451414, #330C0C, true));

  pantallas[1] = new PantallaJuego("JUEGO", fondoJuego, avatar);
  pantallas[2] = new Pantalla("CONFIGURACION", fondo, 0);    // pendiente
  pantallas[3] = new PantallaCreditos("CREDITOS", fondoCreditos, avatar);
  pantallas[4] = new Pantalla("GAMEOVER", fondoGameOver, 0); // Pantalla de derrota en la posición 4

  calcularLayout();
}

void draw() {
  background(0);
  calcularLayout();

  // SI EL BIENESTAR LLEGA A CERO, CAMBIA AUTOMÁTICAMENTE A GAME OVER (Pantalla 4)
  if (actual == 1 && ((PantallaJuego) pantallas[1]).bienestar <= 0) {
    actual = 4; 
  }

  // Fondo (sin deformar, centrado)
  PImage f = pantallas[actual].fondo;
  imageMode(CORNER);
  image(f, offsetX, offsetY, f.width * escalaFondo, f.height * escalaFondo);

  // Animaciones, botones y cursor de la pantalla actual
  pantallas[actual].draw();

  // RENDERIZADO DEL TEXTO DE GAMEOVER (Pantalla 4)
  if (actual == 4) {
    textoRetro("GAM3 OV3R", REF_W / 2, REF_H / 2 - 40, 80, COL_ROJO, CENTER, CENTER);
    textoRetro("PRESIONA ESC PARA VOLVER AL MENU", REF_W / 2, REF_H / 2 + 50, 30, COL_GRIS, CENTER, CENTER);
  }

  // TEMPORAL: mientras CONFIGURACION no tenga su propio diseno, se muestra su nombre
  if (actual == 2) {
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

  // TECLA DE PRUEBA: Presiona 'G' para forzar la pantalla de Game Over manualmente si lo deseas
  if (key == 'g' || key == 'G') {
    actual = 4;
  }

  // En JUEGO las teclas B / R / E son las acciones
  if (actual == 1) ((PantallaJuego) pantallas[1]).teclaPresionada(key, keyCode);

  // ESC vuelve al menu desde cualquier otra pantalla (key = 0 evita que cierre el programa)
  if (key == ESC && actual != 0) {
    actual = 0;
    key = 0;
  }
}
