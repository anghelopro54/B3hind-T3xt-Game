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

  PGraphics fondoCreditos = createGraphics(1920, 1080);
  PGraphics fondoConfiguracion = createGraphics(1920, 1080);

  fondoCreditos.beginDraw();
  fondoCreditos.textFont(fuente);
  fondoCreditos.textSize(48);
  fondoCreditos.background(40, 30, 70);

  fondoCreditos.fill(150, 179, 230);
  fondoCreditos.stroke(20, 20, 60);
  fondoCreditos.strokeWeight(6);
  fondoCreditos.rect(1700, 43, 200, 65, 20);

  fondoCreditos.fill(94, 104, 115);
  fondoCreditos.stroke(38, 109, 191);
  fondoCreditos.strokeWeight(40);
  fondoCreditos.rectMode(CENTER);
  fondoCreditos.rect(fondoCreditos.width/2, fondoCreditos.height/2, 1350, 950, 10);
  fondoCreditos.rectMode(CORNER);

  fondoCreditos.fill(70, 142, 224);
  fondoCreditos.stroke(255);
  fondoCreditos.strokeWeight(2);
  fondoCreditos.rectMode(CENTER);
  fondoCreditos.rect(1490, 66, 40, 30, 10);

  fondoCreditos.fill(70, 142, 224);
  fondoCreditos.stroke(255);
  fondoCreditos.strokeWeight(2);
  fondoCreditos.rectMode(CENTER);
  fondoCreditos.rect(1540, 66, 40, 30, 10);

  fondoCreditos.fill(250, 12, 12);
  fondoCreditos.stroke(255);
  fondoCreditos.strokeWeight(2);
  fondoCreditos.rectMode(CENTER);
  fondoCreditos.rect(1590, 66, 40, 30, 10);

  fondoCreditos.fill(255);
  fondoCreditos.textAlign(CENTER, CENTER);
  fondoCreditos.textSize(30);
  fondoCreditos.text("Creditos.exe", 390, 67);

      //Dibujo de las ventanas y boton de la pantalla creditos
  String[] nombres = {"Anghelo Ospino", "Samantha Pertuz", "Claude"};
  String[] descripciones = {
    "Backend & integrator",
    "Frontend & integrator",
    "Graphic designer & programmer"
  };
  float w = 380, h = 560, espacio = 45;
  float x0 = (fondoCreditos.width - (3 * w + 2 * espacio)) / 2;
  float y0 = (fondoCreditos.height - h) / 2;

  fondoCreditos.rectMode(CORNER);

  for(int i = 0; i < 3; i++){
    float x = x0 + i * (w + espacio);

    //banner
    fondoCreditos.fill(150, 170, 230);
    fondoCreditos.stroke(20, 20, 60);
    fondoCreditos.strokeWeight(6);
    fondoCreditos.rect(x, y0, w, h, 20);

    //nombre
    fondoCreditos.fill(20, 20, 60);
    fondoCreditos.textFont(fuente);
    fondoCreditos.textAlign(CENTER, TOP);
    fondoCreditos.textSize(36);
    fondoCreditos.text(nombres[i], x + 20, y0 + 40, w - 40, 80);

    //descripcion
    fondoCreditos.textSize(28);
    fondoCreditos.text(descripciones[i], x + 20, y0 + 150, w - 40, h - 190);

  }

  fondoCreditos.fill(20, 20, 60);
  fondoCreditos.textAlign(CENTER, CENTER);
  fondoCreditos.textSize(37);
  fondoCreditos.text("Volver", 1801, 75);
  fondoCreditos.endDraw();

  //Dibujo de la ventana y botones de la pantalla configuracion
  fondoConfiguracion.beginDraw();
  fondoConfiguracion.textFont(fuente);
  fondoConfiguracion.textSize(48);
  fondoConfiguracion.background(40, 30, 70);

  fondoConfiguracion.fill(150, 179, 230);
  fondoConfiguracion.stroke(20, 20, 60);
  fondoConfiguracion.strokeWeight(6);
  fondoConfiguracion.rect(1700, 43, 200, 65, 20);

  fondoConfiguracion.fill(94, 104, 115);
  fondoConfiguracion.stroke(38, 109, 191);
  fondoConfiguracion.strokeWeight(40);
  fondoConfiguracion.rectMode(CENTER);
  fondoConfiguracion.rect(fondoConfiguracion.width/2, fondoConfiguracion.height/2, 1350, 950, 10);
  fondoConfiguracion.rectMode(CORNER);

  fondoConfiguracion.fill(70, 142, 224);
  fondoConfiguracion.stroke(255);
  fondoConfiguracion.strokeWeight(2);
  fondoConfiguracion.rectMode(CENTER);
  fondoConfiguracion.rect(1490, 66, 40, 30, 10);

  fondoConfiguracion.fill(70, 142, 224);
  fondoConfiguracion.stroke(255);
  fondoConfiguracion.strokeWeight(2);
  fondoConfiguracion.rectMode(CENTER);
  fondoConfiguracion.rect(1540, 66, 40, 30, 10);

  fondoConfiguracion.fill(250, 12, 12);
  fondoConfiguracion.stroke(255);
  fondoConfiguracion.strokeWeight(2);
  fondoConfiguracion.rectMode(CENTER);
  fondoConfiguracion.rect(1590, 66, 40, 30, 10);

  fondoConfiguracion.fill(255);
  fondoConfiguracion.textAlign(CENTER, CENTER);
  fondoConfiguracion.textSize(30);
  fondoConfiguracion.text("Configuracion.exe", 440, 67);

  fondoConfiguracion.fill(20, 20, 60);
  fondoConfiguracion.textAlign(CENTER, CENTER);
  fondoConfiguracion.textSize(37);
  fondoConfiguracion.text("Volver", 1801, 75);
  fondoConfiguracion.endDraw();


  pantallas[2] = new Pantalla("CONFIGURACION", fondoConfiguracion, 1);
  pantallas[2].Ponerboton(0, new Boton("Volver", 1700, 43, 200, 65, fondoConfiguracion), 0);

  pantallas[3] = new Pantalla("Creditos", fondoCreditos, 1);
  pantallas[3].Ponerboton(0, new Boton("Volver", 1700, 43, 200, 65, fondoCreditos), 0);

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
