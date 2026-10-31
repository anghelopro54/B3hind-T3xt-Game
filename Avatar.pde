// Avatar de Ivana: se muestra abajo a la izquierda en un recuadro pequeno.
// La cara cambia segun el nivel de bienestar (0 a 100).
final int FELIZ = 0;
final int CONFUNDIDA = 1;
final int FRUSTRADA = 2;

class Avatar {
  // Posicion y tamano del recuadro en coordenadas del canvas 1920x1080
  float x, y, tam;
  float bienestar;                 // 0 a 100

  // Umbrales: de aqui para arriba se muestra esa cara
  float umbralFeliz = 60;          // bienestar >= 60  -> feliz
  float umbralConfundida = 30;     // bienestar >= 30  -> confundida; menos -> frustrada

  // Reaccion temporal: mientras sea >= 0 se muestra esa cara sin importar el bienestar
  // (el Modo 3 la usa al acertar / fallar). -1 = sin reaccion, manda el bienestar.
  int reaccion = -1;

  PImage[] imagenes = new PImage[3];
  String[] nombres = {"FELIZ", "CONFUNDIDA", "FRUSTRADA"};

  Avatar(float x, float y, float tam, float bienestarInicial) {
    this.x = x;
    this.y = y;
    this.tam = tam;
    this.bienestar = bienestarInicial;

    String[] archivos = {"feliz.jpg", "confundida.jpg", "frustrada.jpg"};
    for (int i = 0; i < 3; i++) {
      imagenes[i] = loadImage(archivos[i]);
      if (imagenes[i] != null) imagenes[i].resize(400, 400);   // las originales son 2048x2048
    }
  }

  // Suma (o resta, con valor negativo) bienestar, siempre entre 0 y 100
  void cambiarBienestar(float cantidad) {
    bienestar = constrain(bienestar + cantidad, 0, 100);
  }

  // Que cara toca segun el bienestar actual
  int estado() {
    if (bienestar >= umbralFeliz) return FELIZ;
    if (bienestar >= umbralConfundida) return CONFUNDIDA;
    return FRUSTRADA;
  }

  // Cara que se esta mostrando: la reaccion si hay una, si no la del bienestar
  int estadoMostrado() {
    return (reaccion >= 0) ? reaccion : estado();
  }

  void reaccionar(int cara) { reaccion = cara; }
  void limpiarReaccion() { reaccion = -1; }

  // Color segun el bienestar (barras del HUD)
  color colorEstado() {
    return colorDe(estado());
  }

  color colorDe(int e) {
    if (e == FELIZ) return color(90, 220, 120);
    if (e == CONFUNDIDA) return color(255, 200, 80);
    return color(240, 70, 70);
  }

  void dibujar() {
    float sx = offsetX + x * escalaFondo;
    float sy = offsetY + y * escalaFondo;
    float s = tam * escalaFondo;
    float b = 6 * escalaFondo;

    pushStyle();
    rectMode(CORNER);
    imageMode(CORNER);

    // recuadro (el borde cambia de color con el estado)
    fill(10, 10, 30, 235);
    stroke(colorDe(estadoMostrado()));
    strokeWeight(5 * escalaFondo);
    rect(sx, sy, s, s, 12 * escalaFondo);

    // cara
    PImage img = imagenes[estadoMostrado()];
    if (img != null) image(img, sx + b, sy + b, s - 2 * b, s - 2 * b);

    // etiqueta con el nombre del estado
    noStroke();
    fill(10, 10, 30, 200);
    rect(sx + b, sy + s - b - 30 * escalaFondo, s - 2 * b, 30 * escalaFondo);
    fill(colorDe(estadoMostrado()));
    textFont(fuente);
    textAlign(CENTER, CENTER);
    textSize(20 * escalaFondo);
    text(nombres[estadoMostrado()], sx + s / 2, sy + s - b - 15 * escalaFondo);
    popStyle();
  }
}
