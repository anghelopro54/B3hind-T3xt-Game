// =====================================================================================
// B3hind T3xt  -  ARCHIVO PRINCIPAL
// Aqui viven: las variables globales, setup() (crea todas las pantallas), draw() (dibuja la
// pantalla activa) y los eventos de mouse / teclado. Para entender el proyecto completo lee GUIA.md.
// =====================================================================================
import processing.video.*;   // intro en video (libreria Video de Processing)
import processing.sound.*;   // musica y efectos (libreria Sound de Processing)

// ---- Indices de pantallas[]: usar estos nombres en vez de numeros sueltos ----
final int P_MENU = 0, P_CINEMATICA = 1, P_CONFIG = 2, P_CREDITOS = 3, P_MODOS = 4, P_MODO1 = 5,
          P_INSTR_M1 = 6, P_INSTR_M3 = 7, P_MODO3 = 8, P_TIENDA = 9, P_INTRO = 10;
final int SALIR = -2;     // destino especial: cerrar el programa (click() devuelve -1 si no paso nada)

Pantalla[] pantallas;     // todas las pantallas del juego (se indexan con las constantes P_...)
int actual = P_INTRO;     // pantalla que se esta mostrando (el juego arranca en la intro)
int pantallaMusica = -1;  // ultima pantalla para la que se decidio la musica
int configVolverA = 0;    // si es > 0, el boton Volver de Configuracion regresa a esa pantalla (la pausa de un modo)

// ---- Objetos compartidos por todo el juego ----
PImage fondo;             // imagen del menu principal (home.jpg)
PFont fuente;             // tipografia pixel
EfectoTv tv;              // lineas de "tele antigua" encima de todo
Movie introVideo;         // video de la intro del estudio
Musica musica;            // musica de fondo y efectos de los botones
inventario invent;        // lo que se compro y equipo en la tienda
Billetera billetera;      // puntos acumulados de todos los modos (para gastar en la tienda)

boolean debug = false;    // tecla D: muestra los rectangulos de los botones y las coordenadas del mouse

// Posicion y escala con la que se dibuja el fondo (lo recalcula calcularLayout cada cuadro).
// Todo el juego se dibuja en un "lienzo virtual" de 1920x1080 y estos 3 valores lo adaptan a la ventana.
float escalaFondo = 1;
float offsetX = 0;
float offsetY = 0;

// fullScreen() debe ir en settings(), no en setup()
void settings() {
  fullScreen();
  pixelDensity(1);
}

// setup() se ejecuta UNA vez al abrir el juego: carga recursos y crea todas las pantallas
void setup() {
  fuente = createFont("pixel.ttf", 48);
  invent = new inventario();
  musica = new Musica(this);
  billetera = new Billetera();
  billetera.reiniciar();    // los puntos empiezan siempre desde el valor inicial (ver Billetera.reiniciar)

  // Al cerrar el programa de cualquier forma (X, boton Stop, SALIR) se vuelven a reiniciar los puntos.
  // Un "shutdown hook" es un trocito de codigo que Java ejecuta justo antes de apagarse.
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run() {
      if (billetera != null) billetera.reiniciar();
    }
  }));

  fondo = loadImage("home.jpg");

  // Todas las pantallas se crean aqui, antes de usarlas (si no, error de null)
  pantallas = new Pantalla[11];

  // MENU: nombre, imagen, cantidad de botones
  pantallas[P_MENU] = new Pantalla("MENU", fondo, 4);
  // Boton(texto, x, y, ancho, alto en pixeles de la imagen original, imagen)  +  pantalla a la que lleva
  pantallas[P_MENU].Ponerboton(0, new Boton("JUGAR",         1176,  768, 424, 100, fondo), P_CINEMATICA);
  pantallas[P_MENU].Ponerboton(1, new Boton("CONFIGURACION", 1128,  888, 520,  96, fondo), P_CONFIG);
  pantallas[P_MENU].Ponerboton(2, new Boton("CREDITOS",      1176, 1000, 424, 100, fondo), P_CREDITOS);
  pantallas[P_MENU].Ponerboton(3, new Boton("SALIR",         1176, 1116, 424,  96, fondo), SALIR);

  pantallas[P_CINEMATICA] = new PantallaJuego();
  pantallas[P_CONFIG] = new PantallaConfiguracion();
  pantallas[P_CREDITOS] = new PantallaCreditos();
  pantallas[P_MODOS] = new PantallaModosJuego();
  pantallas[P_MODO1] = new Modo1();
  pantallas[P_INSTR_M1] = new PantallaInstrucciones("MODO 1: FLAGGED & FILTERED",
    new String[] {
      "Verás caer mensajes de distintos usuarios. Tu misión: leerlos y clasificarlos ANTES de que lleguen al final de la pantalla.",
      "[B]  Bloquear (mensaje tóxico)",
      "[A]  Aprobar (mensaje sano)",
      "Cuando lleves 4 mensajes bloqueados, pulsa [R] para REPORTAR y ganar puntos de bienestar."
    },
    P_MODO1
  );
  pantallas[P_INSTR_M3] = new PantallaInstrucciones("MODO 2: DE-ESCALATE!",
    new String[] {
      "Estalla un conflicto en Vínculo. Ivana debe calmarlo antes de que escale.",
      "[A] [B] [C]  Elige tu respuesta (o haz clic en ella).",
      "Solo una es asertiva: no insulta ni ignora. Acertar suma bienestar; fallar lo resta.",
      "Calma 5 conflictos para ganar."
    },
    P_MODO3
  );
  pantallas[P_MODO3] = new Modo3();
  pantallas[P_TIENDA] = new tienda();
  pantallas[P_INTRO] = new PantallaIntro();

  tv = new EfectoTv();

  // La intro del estudio se reproduce siempre antes del menu
  if (new File(dataPath(ARCHIVO_INTRO)).exists()) introVideo = new Movie(this, ARCHIVO_INTRO);
  calcularLayout();
  pantallas[P_INTRO].reiniciar();
}

// draw() se ejecuta ~60 veces por segundo: dibuja la pantalla activa y el efecto de TV encima
void draw() {
  background(0);

  // si cambio la pantalla, la musica decide si cambia de cancion
  if (actual != pantallaMusica) {
    pantallaMusica = actual;
    musica.alCambiarPantalla(actual);
  }
  calcularLayout();

  // Fondo de la pantalla (sin deformar, centrado), con un leve vaiven vertical
  imageMode(CORNER);
  int dy = round(sin(frameCount * 0.05) * 1.5);
  image(pantallas[actual].fondoEsc, offsetX, offsetY + dy);

  // Animaciones, botones y cursor de la pantalla actual
  pantallas[actual].draw();

  if (debug) dibujarDebug();
  tv.dibujar();
}

// Ayuda para programar (tecla D): rectangulos rojos en los botones y coordenadas del mouse
void dibujarDebug() {
  pushStyle();
  rectMode(CORNER);
  stroke(255, 0, 0);
  noFill();
  strokeWeight(2);
  for (Boton b : pantallas[actual].botones) {
    rect(b.pantallaX(), b.pantallaY(), b.pantallaW(), b.pantallaH());
  }
  fill(255, 255, 0);
  noStroke();
  textAlign(LEFT, TOP);
  textSize(24);
  text("Ventana: " + mouseX + ", " + mouseY, 20, 20);
  text("Imagen:  " + int((mouseX - offsetX) / escalaFondo) + ", " + int((mouseY - offsetY) / escalaFondo), 20, 50);
  popStyle();
}

// Escala el lienzo de la pantalla actual para que quepa en la ventana manteniendo la proporcion
void calcularLayout() {
  PImage f = pantallas[actual].fondo;
  escalaFondo = min((float) width / f.width, (float) height / f.height);
  offsetX = (width  - f.width  * escalaFondo) / 2;
  offsetY = (height - f.height * escalaFondo) / 2;
}

// Se llama al cerrar el juego con SALIR: los puntos vuelven a su valor inicial
void exit() {
  if (billetera != null) billetera.reiniciar();
  super.exit();
}

// Sonido del boton que se acaba de pulsar: cada ventana de modo tiene el suyo, el resto usa el del menu
void sonarBoton(int desde, int destino) {
  if (desde == P_CINEMATICA || desde == P_INTRO) return;               // cinematica e intro: sin sonido
  if (desde == P_MODOS && destino == P_INSTR_M1) musica.efecto("botonmodo1.mp3");
  else if (desde == P_MODOS && destino == P_INSTR_M3) musica.efecto("botonmodo3.mp3");
  else musica.efecto("botonmenu.mp3");
}

// Clic del mouse: la pantalla actual responde con la pantalla a la que hay que ir (o -1 si no hay cambio)
void mousePressed() {
  int desde = actual;
  int destino = pantallas[actual].click();
  if (destino == SALIR || destino >= 0) sonarBoton(desde, destino);
  if (destino == SALIR) {
    exit();
  } else if (destino >= 0) {
    actual = destino;
    pantallas[actual].reiniciar();
  }
}

// Teclado: D = modo debug, ESC = pausa / volver, y el resto se lo pasa a la pantalla actual
void keyPressed() {
  if (key == 'd' || key == 'D') debug = !debug;

  // ESC vuelve al menu desde cualquier otra pantalla (key = 0 evita que Processing cierre el programa)
  if (key == ESC && actual != P_MENU) {
    if (pantallas[actual].capturaEsc()) {
      pantallas[actual].tecla(ESC);          // los modos abren/cierran la pausa; la intro se salta
    } else if (actual == P_CONFIG && configVolverA > 0) {
      actual = configVolverA;                // Configuracion abierta desde la pausa: regresa a la partida
      configVolverA = 0;
      pantallas[actual].reiniciar();
    } else {
      actual = P_MENU;
    }
    key = 0;
  }

  // la pantalla actual recibe la tecla (el Modo 1 usa B, A y R; el Modo 3 usa A, B y C)
  pantallas[actual].tecla(key);
}
