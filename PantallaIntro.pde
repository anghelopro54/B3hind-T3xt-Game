// Intro del estudio: se reproduce siempre al abrir el juego, antes del menu.
// Se puede saltar con clic o cualquier tecla. Al terminar pasa sola al menu (pantallas[0]).
// Requiere la libreria "Video" (Sketch > Importar biblioteca > Administrar bibliotecas > "Video").
final String ARCHIVO_INTRO = "hailuo-03_haz_un_video_de_presentacion_de_logo_de_empresa_de_videojuegos_llamada_KindSigna-0.mp4";

class PantallaIntro extends Pantalla {
  boolean activa = false;

  PantallaIntro() {
    super("INTRO", crearFondoNegro(), 0);
  }

  void reiniciar() {
    if (introVideo == null) { terminar(); return; }     // no hay video: directo al menu
    activa = true;
    introVideo.play();
  }

  void draw() {
    cursor(ARROW);
    if (!activa) return;

    // el video se dibuja entero y centrado, sin deformarse
    if (introVideo.width > 0) {
      float s = min((float) width / introVideo.width, (float) height / introVideo.height);
      pushStyle();
      imageMode(CENTER);
      image(introVideo, width / 2, height / 2, introVideo.width * s, introVideo.height * s);
      popStyle();
    }

    // termino el video?
    if (introVideo.duration() > 0 && introVideo.time() >= introVideo.duration() - 0.1) terminar();
  }

  // pasa al menu (una sola vez)
  void terminar() {
    if (!activa && introVideo != null) return;
    activa = false;
    if (introVideo != null) introVideo.stop();
    actual = 0;
    pantallas[0].reiniciar();
  }

  int click() {
    terminar();
    return -1;
  }

  void tecla(char k) {
    terminar();
  }

  boolean capturaEsc() {
    return true;      // ESC salta la intro en vez de cerrar el juego
  }
}

PGraphics crearFondoNegro() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  pg.background(0);
  pg.endDraw();
  return pg;
}

// Obligatorio con la libreria Video: lee cada cuadro nuevo
void movieEvent(Movie m) {
  m.read();
}
