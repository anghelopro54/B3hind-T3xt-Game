class PantallaConfiguracion extends Pantalla {
  PantallaConfiguracion() {
    super("CONFIGURACION", crearFondoConfiguracion(), 1);
    Ponerboton(0, new Boton("Volver", 1700, 43, 200, 65, fondo), 0);
  }

  // Si se abrio desde la pausa del Modo 1, "Volver" regresa ahi en vez de ir al menu
  int click() {
    int d = super.click();
    if (d == 0 && configVolverA > 0) {
      d = configVolverA;
      configVolverA = 0;
    }
    return d;
  }
}

PGraphics crearFondoConfiguracion() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  ventanaxp(pg, "Configuracion.exe", 440, true);
  pg.endDraw();

  return pg;
}
