class Puntos{
    int points = 0;
    int totalganado = 0;

    Puntos(){
        cargar();
    }

    void ganar(int cantidad){
        if(cantidad <= 0) return;
        points += cantidad;
        totalganado += cantidad;
        guardar();

    }

    boolean puedepagar(int precio){return points >= precio;}

    boolean gastar(int precio){
        if(!puedepagar(precio)) return false;
        points -= points;
        guardar();
        return true;

    }

    void guardar(){
        saveStrings(dataPath("cartera.txt"), new String[] {str(points), str(totalganado)});

    }

    void cargar(){
        String[] t = loadStrings(dataPath("cartera.txt"));
        if(t != null && t.length >= 2){
            points = int(t[10]);
            totalganado = int(t[1]);

        }

    }

}