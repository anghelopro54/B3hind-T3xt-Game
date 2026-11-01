// B3hind T3xt - Menu principal
import processing.video.*;   // intro en video (libreria Video de Processing)
import processing.sound.*;   // musica de fondo (libreria Sound de Processing)

// Los botones se definen en coordenadas de la IMAGEN ORIGINAL (2356 x 1316),
// asi funcionan en cualquier resolucion de pantalla.

PImage fondo;
Pantalla[] pantallas;    // 0 = MENU, 1 = JUEGO, 2 = CONFIGURACION, 3 = CREDITOS, 4 = MODOS, 5 = MODO 1,
                         // 6 = INSTRUCCIONES MODO 1, 7 = INSTRUCCIONES MODO 3, 8 = MODO 3 (DE-ESCALATE!), 9 = TIENDA, 10 = INTRO
int actual = 0;          // (setup lo pone en 10 = intro; luego pasa al menu)  posicion en la lista de la pantalla que se esta mostrando
final int SALIR = -2;    // destino especial: cerrar el programa
EfectoTv tv;             // variable global para efecto de tv antiguo
PFont fuente;
Movie introVideo;        // intro del estudio
Musica musica;           // musica de fondo (ver Musica.pde: ahi se asigna la cancion de cada pantalla)
int pantallaMusica = -1; // ultima pantalla para la que se decidio la musica
inventario invent;
Billetera billetera;      // puntos acumulados de todos los modos (para la tienda)

int configVolverA = 0;     // si es > 0, el boton Volver de Configuracion regresa a esa pantalla (la pausa del Modo 1)

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
  invent = new inventario();
  musica = new Musica(this);
  billetera = new Billetera();
  billetera.reiniciar();      // los puntos empiezan siempre en 0 (por si el juego anterior se cerro con el boton Stop)
  // al cerrar el programa de cualquier forma (X, Stop, SALIR) se escribe 0 en data/billetera.txt
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run() {
      if (billetera != null) billetera.reiniciar();
    }
  }));
  fondo = loadImage("home.jpg");

// Todas las pantallas se crean aqui, antes de usarlas (si no, error de null)
  pantallas = new Pantalla[11];

  // MENU: nombre, imagen, cantidad de botones
  pantallas[0] = new Pantalla("MENU", fondo, 4);
  // nombre, x, y, ancho, alto (pixeles de la imagen original) y a que pantalla lleva
  pantallas[0].Ponerboton(0, new Boton("JUGAR",         1176,  768, 424, 100, fondo), 1);
  pantallas[0].Ponerboton(1, new Boton("CONFIGURACION", 1128,  888, 520,  96, fondo), 2);
  pantallas[0].Ponerboton(2, new Boton("CREDITOS",      1176, 1000, 424, 100, fondo), 3);
  pantallas[0].Ponerboton(3, new Boton("SALIR",         1176, 1116, 424,  96, fondo), SALIR);

  // Las demas pantallas, por ahora sin botones (se vuelve al menu con ESC)
  pantallas[1] = new PantallaJuego();
  pantallas[2] = new PantallaConfiguracion();
  pantallas[3] = new PantallaCreditos();
  pantallas[4] = new PantallaModosJuego();
  pantallas[5] = new Modo1();
  pantallas[6] = new PantallaInstrucciones("MODO 1: FLAGGED & FILTERED",
    new String[] {
      "Verás caer mensajes de distintos usuarios. Tu misión: leerlos y clasificarlos ANTES de que lleguen al final de la pantalla.",
      "[B]  Bloquear (mensaje tóxico)",
      "[A]  Aprobar (mensaje sano)",
      "Cuando lleves 4 mensajes bloqueados, pulsa [R] para REPORTAR y ganar puntos de bienestar."
    },
    5
  );
  pantallas[7] = new PantallaInstrucciones("MODO 3: DE-ESCALATE!",
    new String[] {
      "Estalla un conflicto en Vínculo. Ivana debe calmarlo antes de que escale.",
      "[A] [B] [C]  Elige tu respuesta (o haz clic en ella).",
      "Solo una es asertiva: no insulta ni ignora. Acertar suma bienestar; fallar lo resta.",
      "Calma 5 conflictos para ganar."
    },
    8
  );
  pantallas[8] = new Modo3();
  
  pantallas[9] = new tienda();
  pantallas[10] = new PantallaIntro();

  tv = new EfectoTv();

  // La intro del estudio se reproduce siempre antes del menu
  if (new File(dataPath(ARCHIVO_INTRO)).exists()) introVideo = new Movie(this, ARCHIVO_INTRO);
  actual = 10;
  calcularLayout();
  pantallas[10].reiniciar();
}

void draw() {
  background(0);

  // si cambio la pantalla, la musica decide si cambia de cancion
  if (actual != pantallaMusica) {
    pantallaMusica = actual;
    musica.alCambiarPantalla(actual);
  }
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

// Al cerrar el juego los puntos vuelven a 0: se escribe 0 en data/billetera.txt
void exit() {
  if (billetera != null) billetera.reiniciar();
  super.exit();
}

// Sonido del boton que se acaba de pulsar: cada ventana de modo tiene el suyo, el resto usa el del menu
void sonarBoton(int desde, int destino) {
  if (desde == 1 || desde == 10) return;               // cinematica e intro: sin sonido
  if (desde == 4 && destino == 6) musica.efecto("botonmodo1.mp3");
  else if (desde == 4 && destino == 7) musica.efecto("botonmodo3.mp3");
  else musica.efecto("botonmenu.mp3");
}

void mousePressed() {
  int desde = actual;
  int destino = pantallas[actual].click();   // -1 si no se hizo click en ningun boton
  if (destino == SALIR || destino >= 0) sonarBoton(desde, destino);
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
    if (pantallas[actual].capturaEsc()) {
      pantallas[actual].tecla(ESC);          // el Modo 1 abre/cierra la pausa
    } else if (actual == 2 && configVolverA > 0) {
      actual = configVolverA;                // Configuracion abierta desde la pausa: regresa a la partida
      configVolverA = 0;
      pantallas[actual].reiniciar();
    } else {
      actual = 0;
    }
    key = 0;
  }

  // la pantalla actual recibe la tecla (el Modo 1 usa B, A y R)
  pantallas[actual].tecla(key);
}
