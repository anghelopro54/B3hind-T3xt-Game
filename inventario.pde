final int FONDO_M1 = 0, BORDE_M1 = 1, FONDO_M3 = 2, BORDE_M3 = 3;

class inventario {
  int[] cantidad = {3, 4, 3, 3};
  boolean[][] comprado = new boolean[4][4];
  int[] equipado = new int[4];

  inventario() {
    for (int i = 0; i < 4; i++) {
      comprado[i][0] = true;
      cargar();
    }
  }

  void guardar() {
    String[] t = new String[4];
    for (int i = 0; i < 4; i++) {
      String c = "";
      for (int j = 0; j < cantidad[i]; j++) c += comprado[i][j] ? "1":"0";
      t[i] = c + "," + equipado[i];
    }

    saveStrings(dataPath("tienda.txt"), t);
  }

  void cargar(){
    String[] t = loadStrings(dataPath("tienda.txt"));
    if(t == null || t.length < 4) return;
    for(int i = 0; i < 4; i++){
        String[] p = split(t[i], ',');
        for(int j = 0; j < cantidad[i] && j < p[0].length(); j++) comprado[i][j] = (p[0].charAt(j) == '1');
        equipado[i] = int(p[1]);
    }
  }
}
