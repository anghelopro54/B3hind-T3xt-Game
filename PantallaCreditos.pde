// Pantalla de creditos: hereda todo de Pantalla (draw, click, botones, fondo escalado)
class PantallaCreditos extends Pantalla {
  PantallaCreditos() {
    super("CREDITOS", crearFondoCreditos(), 1);
    Ponerboton(0, new Boton("Volver", 1700, 43, 200, 65, fondo), 0);
  }
}

// Arma la imagen de creditos con codigo y la devuelve (va fuera de la clase para poder usarla en super)
PGraphics crearFondoCreditos() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  ventanaxp(pg, "Creditos.exe", 390, true);

  String[] nombres = {"Anghelo Ospino", "Samantha Pertuz", "Claude", "Gemini"};
  String[] descripciones = {
    "Backend & integrator",
    "Frontend & integrator",
    "Graphic designer & programmer",
    "Graphic designer & programmer"
  };
  // Fotos (carpeta data): Anghelo y Samantha recortadas hasta el torso, Claude y Gemini completas
  String[] archivos = {"anghelo.png", "samantha.png", "claude.png", "gemini.jpg"};

  // Distribucion: n tarjetas del mismo tamano, centradas dentro de la ventana
  int n = nombres.length;
  float w = 280, h = 450, espacio = 40;
  float foto = 240;                                           // lado de la foto (cuadrada)
  float x0 = (pg.width - (n * w + (n - 1) * espacio)) / 2;    // para que el conjunto quede centrado
  float y0 = (pg.height - h) / 2;

  for (int i = 0; i < n; i++) {
    float x = x0 + i * (w + espacio);

    //banner
    pg.fill(150, 170, 230);
    pg.stroke(20, 20, 60);
    pg.strokeWeight(6);
    pg.rect(x, y0, w, h, 20);

    //foto: fondo, imagen y marco
    float fx = x + (w - foto) / 2;
    float fy = y0 + 25;
    pg.noStroke();
    pg.fill(120, 140, 210);                                   // fondo detras de los PNG con transparencia
    pg.rect(fx, fy, foto, foto);
    PImage img = loadImage(archivos[i]);
    if (img != null) pg.image(img, fx, fy, foto, foto);
    pg.noFill();
    pg.stroke(20, 20, 60);
    pg.strokeWeight(4);
    pg.rect(fx, fy, foto, foto);

    //nombre
    pg.fill(20, 20, 60);
    pg.textAlign(CENTER, TOP);
    pg.textSize(28);
    pg.text(nombres[i], x + 20, y0 + 290, w - 40, 50);

    //descripcion
    pg.textSize(24);
    pg.text(descripciones[i], x + 20, y0 + 350, w - 40, 90);
  }

  pg.endDraw();
  return pg;
}
