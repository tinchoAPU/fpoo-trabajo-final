class HudManager{
  
  void drawHud(int puntajeActual, int vidas, int bateriasRecolectadas){
  fill(255);
  textSize(16);
  textAlign(LEFT, CENTER);
  text("SCORE: " + nf(puntajeActual, 6), 30, 20);
  text("VIDAS: " + vidas, 320, 20);
  text("BATERÍAS: " + bateriasRecolectadas + "/10", 500, 20);
  textAlign(CENTER, CENTER);
  }
}
