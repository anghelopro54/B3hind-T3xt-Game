// Moralejas sobre la sana convivencia en redes sociales (se muestran al terminar el Modo 1 y el Modo 3).

String[] moralejasM1Gana = {
  "Detrás de cada perfil hay una persona. Bloquear el odio y apoyar lo sano hace de la red un lugar más seguro para todos.",
  "Reportar a tiempo no es acusar: es cuidar. Una comunidad sana la construyen quienes se atreven a decir basta.",
  "Pensar antes de publicar nos protege a todos. Lo que escribes hoy puede acompañar a alguien por mucho tiempo.",
  "Cada mensaje de odio bloqueado es una persona menos herida. Cuidar la red también es cuidar a los demás."
};

String[] moralejasM1Pierde = {
  "Cuando dejamos pasar el odio, crece. Ignorar el acoso también es una decisión, y sus efectos los sufre otra persona.",
  "Un mensaje cruel puede herir más de lo que imaginas. Antes de escribir, piensa cómo se sentiría quien lo lee.",
  "Cuidar la red cansa, por eso necesitamos apoyarnos: reportar, acompañar y pedir ayuda cuando algo nos supera.",
  "Equivocarse también enseña: la próxima vez, lee con calma, distingue la burla de lo sano y actúa a tiempo."
};

String[] moralejasM3Gana = {
  "Responder con calma y firmeza, sin insultar ni callarse, es la forma más fuerte de resolver un conflicto en línea.",
  "Ser asertivo es decir lo que piensas con respeto. Así se frenan las peleas sin herir a nadie.",
  "Una discusión no se gana con más gritos: se gana escuchando, poniendo límites y proponiendo hablar con calma.",
  "Todo conflicto tiene dos lados. Si dialogamos sin atacar, la red se vuelve un espacio donde cabemos todos."
};

String[] moralejasM3Pierde = {
  "Responder con agresión alimenta el conflicto y quedarse callado deja que el daño siga. El camino es la asertividad.",
  "Insultar enciende la pelea e ignorarla la deja crecer. Pon límites con respeto y busca ayuda si hace falta.",
  "Cuando estés molesto, respira antes de escribir. Un mensaje enviado con rabia rara vez se puede borrar del recuerdo.",
  "Los conflictos no se resuelven con ataques ni con silencio. Aprende a decir \"esto me molesta\" con respeto."
};

// modo: 1 o 3. Devuelve una moraleja al azar para ese modo y ese resultado.
String elegirMoraleja(int modo, boolean gano) {
  String[] lista;
  if (modo == 1) lista = gano ? moralejasM1Gana : moralejasM1Pierde;
  else           lista = gano ? moralejasM3Gana : moralejasM3Pierde;
  return lista[int(random(lista.length))];
}

// Cuadro "MORALEJA" de la pantalla final (coordenadas del canvas 1920x1080)
void dibujarMoraleja(String texto, boolean gano) {
  float e = escalaFondo;
  float bx = offsetX + 360 * e, by = offsetY + 430 * e, bw = 1200 * e, bh = 200 * e;
  pushStyle();
  rectMode(CORNER);
  fill(24, 28, 56, 235);
  stroke(gano ? color(90, 220, 120) : color(240, 70, 70));
  strokeWeight(4 * e);
  rect(bx, by, bw, bh, 14 * e);
  noStroke();
  textFont(fuente);
  textAlign(CENTER, TOP);
  fill(255, 220, 120);
  textSize(24 * e);
  text("MORALEJA", bx + bw / 2, by + 14 * e);
  fill(255);
  textSize(28 * e);
  textLeading(36 * e);
  text(texto, bx + 24 * e, by + 54 * e, bw - 48 * e, bh - 66 * e);
  popStyle();
}
