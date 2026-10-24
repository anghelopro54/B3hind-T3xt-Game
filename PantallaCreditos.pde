class PantallaCreditos extends Pantalla {
  PantallaCreditos() {
    super("CREDITOS", crearFondoCreditos(), 1);
    Ponerboton(0, new Boton("Volver", 1700, 43, 200, 65, fondo), 0);
  }
}

PGraphics crearFondoCreditos() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  ventanaxp(pg, "Creditos.exe", 390, true);

  //Dibujo de las ventanas y boton de la pantalla creditos
  String[] nombres = {"Anghelo Ospino", "Samantha Pertuz", "Claude"};
  String[] descripciones = {
    "Backend & integrator",
    "Frontend & integrator",
    "Graphic designer & programmer"
  };
  float w = 380, h = 560, espacio = 45;
  float x0 = (pg.width - (3 * w + 2 * espacio)) / 2;
  float y0 = (pg.height - h) / 2;


  for (int i = 0; i < 3; i++) {
    float x = x0 + i * (w + espacio);

    //banner
    pg.fill(150, 170, 230);
    pg.stroke(20, 20, 60);
    pg.strokeWeight(6);
    pg.rect(x, y0, w, h, 20);

    //nombre
    pg.fill(20, 20, 60);
    pg.textAlign(CENTER, TOP);
    pg.textSize(36);
    pg.text(nombres[i], x + 20, y0 + 40, w - 40, 80);

    //descripcion
    pg.textSize(28);
    pg.text(descripciones[i], x + 20, y0 + 150, w - 40, h - 190);
  }
  pg.endDraw();

  return pg;
}
