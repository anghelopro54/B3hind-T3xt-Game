// MessageCard - tarjeta visual de un mensaje dentro de la ventana de moderacion.
// Muestra el avatar del usuario, su nombre y el mensaje en un globo de texto.
//
// El estilo cambia segun el tipo:  NEGATIVO = rojo, POSITIVO = verde, NEUTRAL = gris.
// Si el juego no debe delatar el tipo (por ejemplo en niveles dificiles), poner
// revelarTipo = false y la tarjeta se dibuja siempre con el estilo gris.

final int MSG_NEGATIVO = 0;
final int MSG_POSITIVO = 1;
final int MSG_NEUTRAL  = 2;

class MessageCard {
  String usuario;
  String texto;
  int tipo;
  boolean revelarTipo = true;
  boolean mostrarPrefijo = true;  // antepone "[usuario]: " al texto, como en el mockup
  int t0;                         // momento en que aparecio (para la animacion de entrada)

  MessageCard(String usuario, String texto, int tipo) {
    this.usuario = usuario;
    this.texto = texto;
    this.tipo = tipo;
    t0 = millis();
  }

  // Volver a lanzar la animacion de entrada (por si se reutiliza la tarjeta)
  void reiniciar() {
    t0 = millis();
  }

  String textoVisible() {
    return mostrarPrefijo ? "[" + usuario + "]: " + texto : texto;
  }

  int tipoVisible() {
    return revelarTipo ? tipo : MSG_NEUTRAL;
  }

  int colorTipo() {
    int t = tipoVisible();
    if (t == MSG_NEGATIVO) return COL_ROJO;
    if (t == MSG_POSITIVO) return COL_VERDE;
    return COL_GRIS;
  }

  int colorBurbuja() {
    int t = tipoVisible();
    if (t == MSG_NEGATIVO) return #FFE0E4;
    if (t == MSG_POSITIVO) return #DDFBE8;
    return #E6E9F2;
  }

  int colorTextoBurbuja() {
    int t = tipoVisible();
    if (t == MSG_NEGATIVO) return #4A1020;
    if (t == MSG_POSITIVO) return #0F3B24;
    return #23283A;
  }

  int humor() {
    int t = tipoVisible();
    if (t == MSG_NEGATIVO) return H_ENOJADO;
    if (t == MSG_POSITIVO) return H_FELIZ;
    return H_NEUTRAL;
  }

  // Dibuja la tarjeta dentro de la region (x, y, w, h) en px de la imagen original
  void dibujar(float x, float y, float w, float h) {
    float e = easeOut((millis() - t0) / 280.0);
    float cx = sx(x + w / 2);
    float cy = sy(y + h / 2);

    pushMatrix();
    translate(cx, cy + ss(28) * (1 - e));
    scale(0.94 + 0.06 * e);
    translate(-cx, -cy);

    dibujarUsuario(x, y + (h - 230) / 2);
    dibujarGlobo(x + 210, y, w - 210, h);

    popMatrix();
    rectMode(CORNER);
  }

  // Cuadro del usuario (siluetas de colores) con su nombre debajo
  void dibujarUsuario(float x, float y) {
    int[] paleta = {#6C8CFF, #FF8FB8, #8BE0A4, #FFC76B, #B38CFF};
    int fondoUsuario = paleta[abs(usuario.hashCode()) % paleta.length];
    float lado = 160;

    rectMode(CORNER);
    noStroke();
    fill(0, 110);
    rect(sx(x) + ss(6), sy(y) + ss(6), ss(lado), ss(lado), ss(10));
    stroke(colorTipo());
    strokeWeight(max(1.5, ss(5)));
    fill(#1F2A5C);
    rect(sx(x), sy(y), ss(lado), ss(lado), ss(10));

    // silueta: cabeza y hombros recortados dentro del cuadro
    clip(sx(x), sy(y), ss(lado), ss(lado));
    noStroke();
    fill(fondoUsuario);
    ellipse(sx(x + lado / 2), sy(y + lado * 0.40), ss(lado * 0.36), ss(lado * 0.36));
    ellipse(sx(x + lado / 2), sy(y + lado * 0.98), ss(lado * 0.88), ss(lado * 0.62));
    noClip();
    strokeWeight(1);

    float t = tamQueCabe(usuario, ss(200), ss(30));
    textoPx(usuario, sx(x + lado / 2), sy(y + lado + 26), t, COL_TEXTO, CENTER, CENTER);
  }

  // Globo de texto con colita hacia el usuario
  void dibujarGlobo(float x, float y, float w, float h) {
    float bh = min(h, 214);
    float by = y + (h - bh) / 2;
    float ymed = by + bh / 2;

    // sombra
    rectMode(CORNER);
    noStroke();
    fill(0, 90);
    rect(sx(x) + ss(6), sy(by) + ss(7), ss(w), ss(bh), ss(18));

    // colita + globo
    stroke(colorTipo());
    strokeWeight(max(1.5, ss(5)));
    fill(colorBurbuja());
    triangle(sx(x + 4), sy(ymed - 20), sx(x - 30), sy(ymed), sx(x + 4), sy(ymed + 20));
    rect(sx(x), sy(by), ss(w), ss(bh), ss(18));
    noStroke();
    fill(colorBurbuja());
    rect(sx(x) - ss(1), sy(ymed - 15), ss(8), ss(30));    // tapa la union de la colita
    strokeWeight(1);

    // texto ajustado al espacio disponible
    boolean conCarita = revelarTipo;
    float pad = 30;
    float tw = w - 2 * pad - (conCarita ? 84 : 0);
    float th = bh - 2 * 24;
    String t = textoVisible();
    float tam = tamAjustado(t, ss(tw), ss(th), ss(48), ss(22));
    textFont(fuentePixel);
    textSize(tam);
    textLeading(tam * 1.25);
    float usado = lineasNecesarias(t, ss(tw)) * tam * 1.25;
    float ty = sy(by + 24) + max(0, (ss(th) - usado) / 2);
    textAlign(LEFT, TOP);
    fill(colorTextoBurbuja());
    text(t, sx(x + pad), ty, ss(tw), ss(th));

    if (conCarita) {
      caritaRetro(sx(x + w - 54), sy(by + bh - 56), ss(28), humor(), colorTipo());
    }
    rectMode(CORNER);
  }
}
