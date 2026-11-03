// =====================================================================================
// Mensaje: una tarjeta que cae por la pantalla del monitor en el Modo 1.
// Puede ser toxico (hay que bloquear) o sano (aprobar).
// =====================================================================================
final int TOXICO = 0;
final int SANO = 1;

class Mensaje {
  int tipo;               // TOXICO o SANO
  String usuario;
  String texto;
  float x, y, w, h;       // posicion y tamano en coordenadas del canvas 1920x1080
  float velocidad;        // pixeles del canvas por segundo

  Mensaje(int tipo, String usuario, String texto, float x, float y, float w, float h, float velocidad) {
    this.tipo = tipo;
    this.usuario = usuario;
    this.texto = texto;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.velocidad = velocidad;
  }

  // Baja el mensaje. dt = segundos desde el ultimo cuadro (asi la velocidad no depende de los FPS)
  void mover(float dt) {
    y += velocidad * dt;
  }

  // Deteccion de colision con el borde inferior de la pantalla (yLimite)
  boolean llegoAlFinal(float yLimite) {
    return y + h >= yLimite;
  }

  // objetivo = true si es el mensaje que se resolvera con [B] o [A]
  void dibujar(boolean objetivo) {
    float e = escalaFondo;
    float sx = offsetX + x * e;
    float sy = offsetY + y * e;
    float sw = w * e;
    float sh = h * e;

    pushStyle();
    rectMode(CORNER);
    marcoMensaje(sx, sy, sw, sh, invent.equipado[BORDE_M1], objetivo);

    noStroke();
    textFont(fuente);
    textAlign(LEFT, TOP);
    fill(255, 220, 120);
    textSize(15 * e);
    text(usuario, sx + 10 * e, sy + 8 * e);
    fill(255);
    textSize(17 * e);
    textLeading(21 * e);
    text(texto, sx + 10 * e, sy + 30 * e, sw - 20 * e, sh - 34 * e);
    popStyle();
  }
}
