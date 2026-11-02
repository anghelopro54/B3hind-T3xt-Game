// =====================================================================================
// ModoJuego: BASE COMUN de los dos modos jugables (Modo1 y Modo3).
// Aqui esta lo que los dos modos hacen igual, asi no se repite el codigo:
//   - estado de la partida (jugando / victoria / derrota), puntos y avatar de Ivana
//   - menu de pausa (Reanudar, Configuracion, Salir al menu) y su manejo de ESC / clic
//   - cambiar el fondo si compraste otro en la tienda
//   - depositar los puntos en la billetera UNA sola vez al terminar
//   - dibujar el panel de bienestar y la pantalla final (con la moraleja)
// Modo1 y Modo3 "heredan" de esta clase (class Modo1 extends ModoJuego) y solo escriben lo propio.
// =====================================================================================
final int JUGANDO = 0;     // estados de una partida
final int VICTORIA = 1;
final int DERROTA = 2;

class ModoJuego extends Pantalla {
  Avatar avatar;                        // Ivana (abajo a la izquierda)
  int estado = JUGANDO;                 // JUGANDO, VICTORIA o DERROTA
  int puntos = 0;                       // puntos de esta partida (al terminar pasan a la billetera)
  boolean pagado = false;               // true cuando ya se depositaron los puntos de esta partida
  String moraleja = "";                 // mensaje final sobre la sana convivencia
  int numeroModo;                       // 1 o 3: sirve para elegir la moraleja correcta

  MenuPausa menuPausa = new MenuPausa();
  boolean pausado = false;
  boolean volviendoDeConfig = false;    // true mientras se esta en Configuracion abierta desde la pausa
  int fondoAplicado = 0;                // variante de fondo (tienda) que se esta mostrando

  ModoJuego(String nombre, PImage fondo, int numeroModo) {
    super(nombre, fondo, 0);            // 0 botones: cada modo maneja sus propios clics
    this.numeroModo = numeroModo;
  }

  // ---------- fondo (tienda) ----------

  // Cada modo dice como se arma su fondo; la base solo lo cambia cuando equipas otro
  PGraphics crearFondo(int variante) {
    return null;
  }

  // Si equipaste otro fondo en la tienda, lo cambia al entrar al modo
  void actualizarFondo(int equipado) {
    if (equipado != fondoAplicado) {
      ponerFondo(crearFondo(equipado));
      fondoAplicado = equipado;
    }
  }

  // ---------- reinicio ----------

  // Parte comun de reiniciar(). Devuelve false si solo se volvia de Configuracion: en ese caso la partida
  // se conserva y el modo NO debe reiniciar nada mas.
  boolean prepararReinicio(int fondoEquipado) {
    actualizarFondo(fondoEquipado);
    if (volviendoDeConfig) {
      volviendoDeConfig = false;
      return false;
    }
    pausado = false;
    estado = JUGANDO;
    puntos = 0;
    pagado = false;
    return true;
  }

  // Cuando la partida termina, los puntos pasan a la billetera una sola vez y se elige la moraleja
  void depositarPuntos() {
    if (estado != JUGANDO && !pagado) {
      billetera.ganar(puntos);
      moraleja = elegirMoraleja(numeroModo, estado == VICTORIA);
      pagado = true;
    }
  }

  // ---------- pausa y teclado ----------

  // El modo captura ESC (para la pausa) mientras se juega
  boolean capturaEsc() {
    return estado == JUGANDO;           // si la partida termino, ESC vuelve al menu como siempre
  }

  // Pausa / reanuda (Modo1 lo amplia para correr sus temporizadores)
  void alternarPausa() {
    pausado = !pausado;
  }

  // Posicion de este modo dentro de pantallas[] (para volver aqui desde Configuracion)
  int indiceEnPantallas() {
    for (int i = 0; i < pantallas.length; i++) if (pantallas[i] == this) return i;
    return 0;
  }

  // Teclas iguales en los dos modos. Devuelve true si la tecla ya se uso (ESC, pausa o fin de partida).
  boolean teclaComun(char k) {
    if (k == ESC) {
      if (estado == JUGANDO) alternarPausa();
      return true;
    }
    if (pausado) return true;                                        // en pausa no se juega
    if (estado != JUGANDO) {
      if (k == ENTER || k == RETURN) reiniciar();                    // fin de partida: ENTER reintenta
      return true;
    }
    return false;
  }

  // Clic dentro del menu de pausa. Devuelve la pantalla a la que ir, o -1.
  int clickPausa() {
    int op = menuPausa.click();
    if (op == 0) {                         // Reanudar
      alternarPausa();
    } else if (op == 1) {                  // Configuracion (al darle Volver regresa aqui)
      volviendoDeConfig = true;
      configVolverA = indiceEnPantallas();
      return P_CONFIG;
    } else if (op == 2) {                  // Salir al menu
      pausado = false;
      return P_MENU;
    }
    return -1;
  }

  // ---------- dibujo ----------

  // Panel oscuro arriba a la izquierda con la barra de BIENESTAR. Cada modo agrega sus datos debajo
  // (a partir de y + 76). alto = altura total del panel, en el lienzo 1920x1080.
  void dibujarPanelBienestar(float alto) {
    float e = escalaFondo;
    float px = offsetX + 30 * e, py = offsetY + 30 * e, pw = 290 * e;
    rectMode(CORNER);
    textFont(fuente);
    noStroke();
    fill(10, 10, 30, 215);
    rect(px, py, pw, alto * e, 10 * e);

    textAlign(LEFT, TOP);
    fill(255);
    textSize(20 * e);
    text("BIENESTAR", px + 15 * e, py + 12 * e);
    fill(60, 60, 90);
    rect(px + 15 * e, py + 40 * e, pw - 30 * e, 20 * e, 4 * e);
    fill(avatar.colorEstado());                                       // verde / amarillo / rojo segun el bienestar
    rect(px + 15 * e, py + 40 * e, (pw - 30 * e) * avatar.bienestar / 100.0, 20 * e, 4 * e);
  }

  // Pantalla final: velo oscuro, titulo, resumen, ayuda de teclas y cuadro de moraleja
  void dibujarFin(String tituloGano, String tituloPierde, String resumen, String ayuda) {
    float e = escalaFondo;
    boolean gano = (estado == VICTORIA);
    pushStyle();
    rectMode(CORNER);
    noStroke();
    fill(0, 190);
    rect(offsetX, offsetY, 1920 * e, 1080 * e);
    textFont(fuente);
    textAlign(CENTER, CENTER);
    fill(gano ? color(90, 220, 120) : color(240, 70, 70));
    textSize(64 * e);
    text(gano ? tituloGano : tituloPierde, offsetX + 960 * e, offsetY + 300 * e);
    fill(255);
    textSize(28 * e);
    text(resumen, offsetX + 960 * e, offsetY + 370 * e);
    textSize(24 * e);
    text(ayuda, offsetX + 960 * e, offsetY + 700 * e);
    popStyle();
    dibujarMoraleja(moraleja, gano);
  }
}
