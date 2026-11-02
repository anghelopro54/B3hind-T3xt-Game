// =====================================================================================
// Tienda: se compran fondos y bordes con los puntos de la billetera. Cada categoria (fila) tiene varias
// tarjetas; clic en una = comprar (si alcanza el saldo) o equipar (si ya la tienes).
// Los datos de cada tarjeta (nombres y precios) estan en las tablas de abajo: para agregar una opcion
// nueva, anade su nombre y precio, sube inventario.cantidad[] y dibuja su estilo en estilos.pde.
// =====================================================================================
class tienda extends Pantalla {
  String[] categorias = {"MODO 1 · FONDO DE PC", "MODO 1 · BORDE DE MENSAJES",
                         "MODO 2 · FONDO DE HABITACIÓN Y PC", "MODO 2 · BORDE DE OPCIONES"};
  String[][] nombres = {{"Original", "Noche azul", "Rosa pastel", "Atardecer", "Matrix"},
                        {"Clásico", "Neón", "Dorado", "Rosa doble", "Fuego", "Hielo"},
                        {"Original", "Noche azul", "Rosa pastel", "Atardecer", "Matrix"},
                        {"Clásico", "Neón cian", "Dorado doble", "Rosa neón", "Verde pixel"}};
  int[][] precios = {{0, 200, 250, 300, 350},
                     {0, 100, 150, 150, 200, 200},
                     {0, 200, 250, 300, 350},
                     {0, 100, 150, 150, 200}};

  float cardW = 158, cardH = 110, gap = 10, x0 = 461;      // canvas 1920x1080 (caben hasta 6 tarjetas por fila)
  PImage[][] miniaturas = new PImage[4][6];
  boolean miniaturasListas = false;
  String aviso = "";
  int avisoHasta = 0;

  tienda() {
    super("TIENDA", crearFondoTienda(), 1);
    Ponerboton(0, new Boton("Volver", 1700, 43, 200, 65, fondo), P_MODOS);
  }

  // Posicion de la tarjeta: columna v (opcion) y fila s (categoria), en el lienzo 1920x1080
  float cardX(int v) { return x0 + v * (cardW + gap); }
  float cardY(int s) { return 270 + s * 155; }

  // Al entrar: arma las miniaturas de los fondos (solo la primera vez)
  void reiniciar() {
    if (!miniaturasListas) {                 // se arman una sola vez (cargar imágenes grandes tarda)
      for (int v = 0; v < 5; v++) {
        miniaturas[0][v] = crearFondoModo1(v).get();  miniaturas[0][v].resize(160, 90);
        miniaturas[2][v] = crearFondoModo3(v).get();  miniaturas[2][v].resize(160, 90);
      }
      miniaturasListas = true;
    }
    aviso = "";
  }

  // devuelve s*10+v de la tarjeta bajo el mouse, o -1
  int tarjetaEncima() {
    float e = escalaFondo;
    for (int s = 0; s < 4; s++)
      for (int v = 0; v < invent.cantidad[s]; v++) {
        float x = offsetX + cardX(v) * e, y = offsetY + cardY(s) * e;
        if (mouseX >= x && mouseX <= x + cardW * e && mouseY >= y && mouseY <= y + cardH * e) return s * 10 + v;
      }
    return -1;
  }

  // Dibuja saldo, titulos de categoria, tarjetas y el aviso temporal
  void draw() {
    super.draw();                                           // botón Volver
    float e = escalaFondo;
    int sobre = tarjetaEncima();
    if (sobre >= 0) cursor(HAND);

    pushStyle();
    textFont(fuente);
    textAlign(LEFT, CENTER);
    fill(255, 220, 120);
    textSize(26 * e);
    text("SALDO: " + billetera.saldo, offsetX + 470 * e, offsetY + 205 * e);

    for (int s = 0; s < 4; s++) {
      fill(255);
      textSize(20 * e);
      textAlign(LEFT, CENTER);
      text(categorias[s], offsetX + 470 * e, offsetY + (cardY(s) - 16) * e);
      for (int v = 0; v < invent.cantidad[s]; v++) dibujarTarjeta(s, v, sobre == s * 10 + v);
    }

    if (millis() < avisoHasta) {
      fill(255, 220, 120);
      textAlign(CENTER, CENTER);
      textSize(22 * e);
      text(aviso, offsetX + 960 * e, offsetY + 895 * e);
    }
    popStyle();
  }

  // Una tarjeta: vista previa, nombre y estado (EQUIPADO / EQUIPAR / COMPRAR precio / faltan N)
  void dibujarTarjeta(int s, int v, boolean sobre) {
    float e = escalaFondo;
    float x = offsetX + cardX(v) * e, y = offsetY + cardY(s) * e, w = cardW * e, h = cardH * e;
    boolean equipada = (invent.equipado[s] == v);
    boolean tengo = invent.comprado[s][v];

    rectMode(CORNER);
    fill(sobre ? color(200, 220, 255) : color(150, 179, 230));
    stroke(equipada ? color(60, 200, 100) : color(20, 20, 60));
    strokeWeight((equipada ? 6 : 4) * e);
    rect(x, y, w, h, 14 * e);

    // vista previa
    if (s == 0 || s == 2) {
      if (miniaturas[s][v] != null) image(miniaturas[s][v], x + (w - 92 * e) / 2, y + 8 * e, 92 * e, 52 * e);
    } else if (s == 1) {
      marcoMensaje(x + 25 * e, y + 10 * e, w - 50 * e, 48 * e, v, false);
    } else {
      marcoOpcion(x + 25 * e, y + 10 * e, w - 50 * e, 48 * e, color(150, 179, 230), color(20, 20, 60), v, true);
    }

    noStroke();
    textAlign(CENTER, CENTER);
    fill(20, 20, 60);
    textSize(15 * e);
    text(nombres[s][v], x + w / 2, y + 72 * e);

    String estado;
    if (equipada)                                  { estado = "EQUIPADO"; fill(20, 130, 60); }
    else if (tengo)                                { estado = "EQUIPAR"; fill(20, 20, 60); }
    else if (billetera.puedePagar(precios[s][v]))  { estado = "COMPRAR  " + precios[s][v]; fill(20, 20, 60); }
    else                                           { estado = "faltan " + (precios[s][v] - billetera.saldo); fill(190, 30, 40); }
    textSize(16 * e);
    text(estado, x + w / 2, y + 94 * e);
  }

  // Clic: Volver, o comprar / equipar la tarjeta bajo el mouse
  int click() {
    int d = super.click();                         // ¿Volver?
    if (d >= 0) return d;
    int t = tarjetaEncima();
    if (t < 0) return -1;
    int s = t / 10, v = t % 10;

    if (invent.comprado[s][v]) {
      invent.equipado[s] = v;
      invent.guardar();
      avisar("Equipado: " + nombres[s][v]);
    } else if (billetera.gastar(precios[s][v])) {
      invent.comprado[s][v] = true;
      invent.equipado[s] = v;                  // al comprar se equipa solo
      invent.guardar();
      avisar("¡Compraste " + nombres[s][v] + "!");
    } else {
      avisar("Te faltan " + (precios[s][v] - billetera.saldo) + " puntos");
    }
    return -1;
  }

  void avisar(String t) { aviso = t; avisoHasta = millis() + 2000; }
}

// Fondo de la tienda: la misma ventana XP de Creditos
PGraphics crearFondoTienda() {
  PGraphics pg = createGraphics(1920, 1080);
  pg.beginDraw();
  PImage img = loadImage("Ventanas.jpg");
  if (img != null) imagenCover(pg, img);
  ventanaxp(pg, "Tienda.exe", 440, true, img);      // misma ventana que Créditos; dibuja también el botón "Volver"
  pg.endDraw();
  return pg;
}