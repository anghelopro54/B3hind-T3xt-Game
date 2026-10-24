class PantallaConfiguracion extends Pantalla {
  PantallaConfiguracion() {
    super("CONFIGURACION", crearFondoConfiguracion(), 1);
    Ponerboton(0, new Boton("Volver", 1700, 43, 200, 65, fondo), 0);
  }
}

PGraphics crearFondoConfiguracion() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  ventanaxp(pg, "Configuracion.exe", 440, true);
  pg.endDraw();

  return pg;
}
