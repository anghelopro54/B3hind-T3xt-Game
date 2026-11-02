// =====================================================================================
// Musica de fondo y efectos de sonido (libreria "Sound": Sketch > Importar biblioteca > Administrar bibliotecas > "Sound").
// Hay una sola instancia global: musica. Los archivos de audio estan en la carpeta data.
// Cada vez que cambia la pantalla, main llama a alCambiarPantalla(). Si la pantalla tiene una cancion asignada
// en archivoPara(), se reproduce en bucle; si es la misma que ya suena, no se reinicia. Si la pantalla devuelve null,
// la musica que suena se queda como esta.
// =====================================================================================
class Musica {
  PApplet app;
  String[] nombres = new String[12];       // canciones ya cargadas (para no cargarlas dos veces)
  SoundFile[] archivos = new SoundFile[12];
  int cargadas = 0;
  SoundFile sonando = null;
  String nombreSonando = "";
  final float MAX_EFECTOS = 0.4;           // tope de volumen de los botones (barra de Configuracion al 100%)
  final float MAX_MUSICA = 0.7;           // tope de volumen de la musica (barra de Configuracion al 100%)
  float volumenEfectos = MAX_EFECTOS;      // volumen actual de los sonidos de los botones
  float volumen = MAX_MUSICA;              // volumen actual de la musica

  Musica(PApplet app) {
    this.app = app;
  }

  // Cancion de cada pantalla (indices de pantallas[] en B3hind_T3xt.pde). null = no cambiar la musica.
  String archivoPara(int pantalla) {
    switch (pantalla) {
    case 0:      // menu principal
    case 2:      // configuracion
    case 3:      // creditos
    case 4:      // eleccion de modos
      return "menu.mp3";
    case 6:      // instrucciones del Modo 1
    case 5:      // Modo 1 (sigue la misma cancion; si ya suena, no se reinicia)
      return "modo1.mp3";
    case 7:      // instrucciones del Modo 3
    case 8:      // Modo 3
      return "modo3.mp3";
    case 9:      // tienda
      return "tienda.mp3";
    default:
      return null;   // sin cambios
    }
  }

  // Main lo llama cada vez que cambia la pantalla activa
  void alCambiarPantalla(int pantalla) {
    String nombre = archivoPara(pantalla);
    if (nombre == null || nombre.equals(nombreSonando)) return;
    reproducir(nombre);
  }

  // Cambia la cancion de fondo (en bucle)
  void reproducir(String nombre) {
    SoundFile nuevo = cargar(nombre);
    if (nuevo == null) return;               // el archivo no existe: se queda como esta
    if (sonando != null) sonando.stop();
    sonando = nuevo;
    nombreSonando = nombre;
    sonando.loop();
    sonando.amp(volumen);
  }

  // Sonido corto (clic de boton): suena una vez, sin cortar la musica de fondo
  void efecto(String nombre) {
    SoundFile f = cargar(nombre);
    if (f == null) return;
    f.play();
    f.amp(volumenEfectos);                   // despues de play(): play() deja el volumen en 1.0
  }

  // Devuelve el SoundFile del archivo, cargandolo solo la primera vez (null si el archivo no existe)
  SoundFile cargar(String nombre) {
    for (int i = 0; i < cargadas; i++) if (nombres[i].equals(nombre)) return archivos[i];
    if (!new File(dataPath(nombre)).exists()) {
      println("Musica: no existe data/" + nombre);
      return null;
    }
    if (cargadas >= nombres.length) return null;
    nombres[cargadas] = nombre;
    archivos[cargadas] = new SoundFile(app, nombre);
    cargadas++;
    return archivos[cargadas - 1];
  }

  // Para la musica de fondo
  void detener() {
    if (sonando != null) sonando.stop();
    sonando = null;
    nombreSonando = "";
  }
}
