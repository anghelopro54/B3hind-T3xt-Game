// Borde de los mensajes del Modo 1: 0 Clásico, 1 Neón, 2 Dorado, 3 Rosa doble, 4 Fuego, 5 Hielo
void marcoMensaje(float x, float y, float w, float h, int estilo, boolean objetivo) {
  float e = escalaFondo;
  rectMode(CORNER);
  if (estilo == 0) {                                   // el de siempre
    fill(24, 28, 56, 240);
    stroke(objetivo ? color(255, 220, 120) : color(120, 140, 200));
    strokeWeight((objetivo ? 3 : 2) * e);
    rect(x, y, w, h, 6 * e);
    return;
  }
  if (estilo == 1) {                                   // neón verde con resplandor
    noFill(); stroke(0, 255, 150, 70); strokeWeight(10 * e);
    rect(x, y, w, h, 6 * e);
    fill(24, 28, 56, 240); stroke(0, 255, 150); strokeWeight(3 * e);
    rect(x, y, w, h, 6 * e);
  } else if (estilo == 2) {                            // dorado con línea interior
    fill(24, 28, 56, 240); stroke(255, 200, 60); strokeWeight(4 * e);
    rect(x, y, w, h, 6 * e);
    noFill(); stroke(255, 240, 170); strokeWeight(1.5 * e);
    rect(x + 6 * e, y + 6 * e, w - 12 * e, h - 12 * e, 3 * e);
  } else if (estilo == 3) {                            // rosa + celeste, doble
    fill(24, 28, 56, 240); stroke(255, 90, 200); strokeWeight(3 * e);
    rect(x, y, w, h, 6 * e);
    noFill(); stroke(120, 220, 255); strokeWeight(2 * e);
    rect(x + 6 * e, y + 6 * e, w - 12 * e, h - 12 * e, 3 * e);
  } else if (estilo == 4) {                            // fuego: naranja con resplandor rojo
    noFill(); stroke(255, 60, 0, 80); strokeWeight(10 * e);
    rect(x, y, w, h, 6 * e);
    fill(24, 28, 56, 240); stroke(255, 120, 30); strokeWeight(4 * e);
    rect(x, y, w, h, 6 * e);
    noFill(); stroke(255, 210, 90); strokeWeight(1.5 * e);
    rect(x + 6 * e, y + 6 * e, w - 12 * e, h - 12 * e, 3 * e);
  } else {                                             // hielo: celeste con brillo blanco
    noFill(); stroke(200, 240, 255, 90); strokeWeight(9 * e);
    rect(x, y, w, h, 6 * e);
    fill(24, 28, 56, 240); stroke(150, 220, 255); strokeWeight(3 * e);
    rect(x, y, w, h, 6 * e);
    noFill(); stroke(255, 255, 255, 210); strokeWeight(1.5 * e);
    rect(x + 6 * e, y + 6 * e, w - 12 * e, h - 12 * e, 3 * e);
  }
  if (objetivo) {                                      // sigue marcándose cuál se resuelve con [B]/[A]
    noFill(); stroke(255, 220, 120); strokeWeight(3 * e);
    rect(x - 5 * e, y - 5 * e, w + 10 * e, h + 10 * e, 9 * e);
  }
}

// Borde de las opciones del Modo 3: 0 Clásico, 1 Neón cian, 2 Dorado doble, 3 Rosa neón, 4 Verde pixel
// "normal" = false cuando la opción está en acierto/error/apagada: ahí se conservan los colores de estado.
void marcoOpcion(float x, float y, float w, float h, color relleno, color borde, int estilo, boolean normal) {
  float e = escalaFondo;
  rectMode(CORNER);
  if (!normal || estilo == 0) {
    fill(relleno); stroke(borde); strokeWeight(6 * e);
    rect(x, y, w, h, 20 * e);
  } else if (estilo == 1) {
    noFill(); stroke(0, 230, 255, 80); strokeWeight(14 * e);
    rect(x, y, w, h, 20 * e);
    fill(relleno); stroke(0, 200, 255); strokeWeight(5 * e);
    rect(x, y, w, h, 20 * e);
  } else if (estilo == 2) {
    fill(relleno); stroke(255, 200, 60); strokeWeight(7 * e);
    rect(x, y, w, h, 20 * e);
    noFill(); stroke(255, 245, 190); strokeWeight(2 * e);
    rect(x + 10 * e, y + 10 * e, w - 20 * e, h - 20 * e, 12 * e);
  } else if (estilo == 3) {                            // rosa neón con resplandor
    noFill(); stroke(255, 90, 200, 80); strokeWeight(14 * e);
    rect(x, y, w, h, 20 * e);
    fill(relleno); stroke(255, 60, 190); strokeWeight(5 * e);
    rect(x, y, w, h, 20 * e);
  } else {                                             // verde pixel: borde grueso con línea clara adentro
    fill(relleno); stroke(40, 170, 90); strokeWeight(8 * e);
    rect(x, y, w, h, 6 * e);
    noFill(); stroke(190, 255, 200); strokeWeight(2 * e);
    rect(x + 10 * e, y + 10 * e, w - 20 * e, h - 20 * e, 3 * e);
  }
}