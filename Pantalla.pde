// =====================================================================================
// Pantalla: clase BASE de todas las pantallas del juego (menu, creditos, modos, tienda...).
// Cada pantalla tiene un fondo, una lista de botones y a donde lleva cada boton.
// Las pantallas especiales (Modo1, Modo3, tienda...) heredan de esta clase y reescriben
// los metodos que necesiten (draw, click, tecla...).
// =====================================================================================
class Pantalla {
  String nombre;
  PImage fondo;          // imagen original (el lienzo virtual, normalmente 1920x1080)
  PImage fondoEsc;       // la misma imagen ya escalada al tamano de la ventana
  Boton[] botones;
  int[] destinos;        // destinos[i] = a que pantalla (indice de pantallas[]) lleva botones[i]

  // cb = cantidad de botones que tendra la pantalla
  Pantalla(String nombre, PImage fondo, int cb) {
    this.nombre = nombre;
    ponerFondo(fondo);
    botones = new Boton[cb];
    destinos = new int[cb];
  }

  // Cambia el fondo (tambien se usa al comprar un fondo nuevo en la tienda)
  void ponerFondo(PImage nuevo) {
    fondo = nuevo;
    fondoEsc = escalarPantalla(nuevo);
  }

  // Pone el boton i y la pantalla a la que lleva
  void Ponerboton(int i, Boton boton, int destino) {
    botones[i] = boton;
    destinos[i] = destino;
  }

  // Anima y dibuja los botones; cambia el cursor a manito si el mouse esta encima de alguno
  void draw() {
    boolean encima = false;
    for (Boton b : botones) {
      b.actualizar(mouseX, mouseY);
    }
    for (Boton b : botones) {
      b.dibujar();
      if (b.estaEncima(mouseX, mouseY)) encima = true;
    }
    cursor(encima ? HAND : ARROW);
  }

  // Clic del mouse. Devuelve la pantalla a la que hay que ir, o -1 si no se pulso ningun boton
  int click() {
    for (int i = 0; i < botones.length; i++) {
      if (botones[i].estaEncima(mouseX, mouseY)) {
        botones[i].presionar();
        return destinos[i];
      }
    }
    return -1;
  }

  void reiniciar() {         // se llama al entrar a la pantalla (las que lo necesitan lo reescriben)
  }

  void tecla(char k) {       // se llama al pulsar una tecla (las que lo necesitan lo reescriben)
  }

  // true si la pantalla quiere manejar ESC ella misma (los modos lo usan para la pausa)
  boolean capturaEsc() {
    return false;
  }
}

// ---------------------------------------------------------------------------------
// Dibujo de ventanas estilo Windows XP (Configuracion, Creditos, Tienda)
// ---------------------------------------------------------------------------------

// Boton redondeado azul claro dibujado en un PGraphics (el que se ve en "Volver", "Jugar", etc.)
void dibujarBotonXP(PGraphics pg, String texto, float x, float y, float w, float h) {
  pg.rectMode(CORNER);
  pg.fill(150, 179, 230);
  pg.stroke(20, 20, 60);
  pg.strokeWeight(6);
  pg.rect(x, y, w, h, 20);
  pg.fill(20, 20, 60);
  pg.textAlign(CENTER, CENTER);
  pg.textSize(37);
  pg.text(texto, x + w / 2, y + h / 2);
}

// Ventana XP con fondo de color plano
void ventanaxp(PGraphics pg, String titulo, float xTitulo, boolean volver) {
  ventanaxp(pg, titulo, xTitulo, volver, null);
}

// Ventana XP con imagen de fondo (si fondoImg es null, usa el color plano).
// volver = true dibuja tambien el boton "Volver" arriba a la derecha.
void ventanaxp(PGraphics pg, String titulo, float xTitulo, boolean volver, PImage fondoImg) {
  pg.textFont(fuente);
  if (fondoImg != null) imagenCover(pg, fondoImg);
  else pg.background(40, 30, 70);

  // tamano de la ventana y cuanto se encogio respecto a la original (1350 x 950)
  float vw = 1100, vh = 800;
  float dx = (1350 - vw) / 2;     // 125
  float dy = (950 - vh) / 2;      // 75

  if (volver) dibujarBotonXP(pg, "Volver", 1700, 43, 200, 65);

  pg.rectMode(CENTER);
  pg.fill(94, 104, 115);
  pg.stroke(140, 70, 200);                 // borde morado (cambia aqui el color)
  pg.strokeWeight(40);
  pg.rect(pg.width / 2, pg.height / 2, vw, vh, 10);

  // botones de la barra de titulo (siguen la esquina superior derecha de la ventana)
  pg.stroke(255);
  pg.strokeWeight(2);
  pg.fill(70, 142, 224);
  pg.rect(1490 - dx, 66 + dy, 40, 30, 10);
  pg.rect(1540 - dx, 66 + dy, 40, 30, 10);
  pg.fill(250, 12, 12);
  pg.rect(1590 - dx, 66 + dy, 40, 30, 10);

  // titulo (sigue la esquina superior izquierda)
  pg.fill(255);
  pg.textAlign(CENTER, CENTER);
  pg.textSize(30);
  pg.text(titulo, xTitulo + dx, 67 + dy);

  pg.rectMode(CORNER);
}
