// =====================================================================================
// Billetera: los puntos acumulados de todos los modos, que se gastan en la tienda.
// Hay una sola instancia global: billetera (se crea en setup de B3hind_T3xt.pde).
// Se guarda en data/billetera.txt (linea 1 = saldo, linea 2 = total ganado).
// =====================================================================================
class Billetera {
  int saldo = 0;          // lo que se puede gastar en la tienda
  int totalGanado = 0;    // historial

  Billetera() { cargar(); }

  // Suma puntos (al terminar una partida)
  void ganar(int cantidad) {
    if (cantidad <= 0) return;
    saldo += cantidad;
    totalGanado += cantidad;
    guardar();
  }

  // Deja los puntos en su valor inicial y lo escribe en data/billetera.txt.
  // Se llama al abrir y al cerrar el juego. (Valor de prueba: 99999999; para la entrega pon 0.)
  void reiniciar() {
    saldo = 99999999;
    totalGanado = 0;
    guardar();
  }

  boolean puedePagar(int precio) { return saldo >= precio; }

  // Descuenta el precio. Devuelve true si la compra se pudo hacer
  boolean gastar(int precio) {
    if (!puedePagar(precio)) return false;
    saldo -= precio;
    guardar();
    return true;
  }

  // Se guarda en data/billetera.txt para no perder los puntos
  void guardar() {
    saveStrings(dataPath("billetera.txt"), new String[] { str(saldo), str(totalGanado) });
  }

  // Lee data/billetera.txt (si no existe, se queda en 0)
  void cargar() {
    String[] l = loadStrings(dataPath("billetera.txt"));
    if (l != null && l.length >= 2) {
      saldo = int(l[0]);
      totalGanado = int(l[1]);
    }
  }
}
