// =====================================================================================
// inventario: que cosas de la tienda compraste y cual tienes equipada en cada categoria.
// Hay una sola instancia global: invent. Se guarda en data/tienda.txt.
// =====================================================================================

// Las 4 categorias de la tienda (indice "s" en tienda.pde e inventario)
final int FONDO_M1 = 0, BORDE_M1 = 1, FONDO_M3 = 2, BORDE_M3 = 3;

class inventario {
  int[] cantidad = {5, 6, 5, 5};                 // cuantas opciones tiene cada categoria
  boolean[][] comprado = new boolean[4][6];      // comprado[categoria][opcion]
  int[] equipado = new int[4];                   // opcion equipada en cada categoria (0 = la de siempre)

  inventario() {
    for (int i = 0; i < 4; i++) comprado[i][0] = true;   // la opcion 0 de cada categoria ya es tuya
    cargar();
  }

  // Formato de cada linea de tienda.txt:  "10110,2"  = bits de comprado, opcion equipada
  void guardar() {
    String[] t = new String[4];
    for (int i = 0; i < 4; i++) {
      String c = "";
      for (int j = 0; j < cantidad[i]; j++) c += comprado[i][j] ? "1" : "0";
      t[i] = c + "," + equipado[i];
    }
    saveStrings(dataPath("tienda.txt"), t);
  }

  // Lee data/tienda.txt y deja marcado lo comprado y lo equipado
  void cargar() {
    String[] t = loadStrings(dataPath("tienda.txt"));
    if (t == null || t.length < 4) return;
    for (int i = 0; i < 4; i++) {
      String[] p = split(t[i], ',');
      for (int j = 0; j < cantidad[i] && j < p[0].length(); j++) comprado[i][j] = (p[0].charAt(j) == '1');
      equipado[i] = int(p[1]);
    }
  }
}
