// Puntos acumulados de todos los modos. Hay una sola instancia global: billetera (en B3hind_T3xt.pde).
class Billetera {
  int saldo = 0;          // lo que se puede gastar en la tienda
  int totalGanado = 0;    // historial

  Billetera() { cargar(); }

  void ganar(int cantidad) {
    if (cantidad <= 0) return;
    saldo += cantidad;
    totalGanado += cantidad;
    guardar();
  }

  // Pone los puntos en 0 y lo escribe en data/billetera.txt (se llama al cerrar el juego)
  void reiniciar() {
    saldo = 999999;
    totalGanado = 0;
    guardar();
  }

  boolean puedePagar(int precio) { return saldo >= precio; }

  // devuelve true si la compra se pudo hacer
  boolean gastar(int precio) {
    if (!puedePagar(precio)) return false;
    saldo -= precio;
    guardar();
    return true;
  }

  // se guarda en data/billetera.txt para no perder los puntos al cerrar el juego
  void guardar() {
    saveStrings(dataPath("billetera.txt"), new String[] { str(saldo), str(totalGanado) });
  }

  void cargar() {
    String[] l = loadStrings(dataPath("billetera.txt"));
    if (l != null && l.length >= 2) {
      saldo = int(l[0]);
      totalGanado = int(l[1]);
    }
  }
}
