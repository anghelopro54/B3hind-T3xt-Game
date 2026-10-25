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
  
  // Cargar y dibujar la imagen de fondo "Ventanas.jpg" a pantalla completa usando imagenCover
  PImage fondoVentanas = loadImage("Ventanas.jpg");
  if (fondoVentanas != null) {
    imagenCover(pg, fondoVentanas);
  } else {
    pg.background(40, 30, 70); // Color de respaldo por si llegara a faltar la imagen
  }

  // Dibuja la ventana XP de créditos encima del nuevo fondo
  ventanaxp(pg, "Creditos.exe", 390, true, loadImage("Ventanas.jpg"));

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
  float w = 230, h = 420, espacio = 25;
  float foto = 200;
  float x0 = (pg.width - (n * w + (n - 1) * espacio)) / 2;
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
    pg.textSize(22);
    pg.text(nombres[i], x + 10, y0 + 250, w - 20, 40);

    //descripcion
    pg.textSize(20);
    pg.text(descripciones[i], x + 15, y0 + 300, w - 30, 100);
  }

  pg.endDraw();
  return pg;
}
