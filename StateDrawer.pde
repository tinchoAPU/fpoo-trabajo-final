class StateDrawer{
  
  
  void dibujarPresentacion() {
  background(5, 8, 18);
  
  int tiempoTranscurrido = millis() - tiempoInicioPresentacion;
  
  stroke(0, 100, 180, 40);
  strokeWeight(1);
  float offsetGrid = (frameCount * 1.5) % 30;
  for (float y = 0; y < height; y += 30) {
    line(0, y + offsetGrid, width, y + offsetGrid);
  }
  for (float x = 0; x < width; x += 40) {
    line(x, 0, x, height);
  }
  
  pushMatrix();
  translate(width/2, 110);
  
  float rx = random(-1.5, 1.5);
  float ry = random(-1.5, 1.5);
  
  fill(0, 200, 255, 90);
  textSize(66);
  textAlign(CENTER, CENTER);
  text("VOLT-X", rx + 3, ry + 3);
  text("VOLT-X", rx - 3, ry - 3);
  
  fill(240, 255, 255);
  textSize(64);
  text("VOLT-X", rx, ry);
  popMatrix();
  
  fill(0, 255, 180);
  textSize(16);
  text("— ESCAPE DE CHATARRA —", width/2, 170);

  int charsVisibles = min(historiaVoltX.length(), tiempoTranscurrido / 40);
  String textoProgresivo = historiaVoltX.substring(0, charsVisibles);
  
  fill(200, 220, 240);
  textSize(18);
  rectMode(CENTER);
  text(textoProgresivo, width/2, height/2 + 40);
  rectMode(CORNER);

  if ((frameCount / 25) % 2 == 0) {
    fill(255, 200, 0);
    textSize(14);
    text("[ PRESIONA ENTER PARA OMITIR ]", width/2, height - 50);
  }
  
  if (tiempoTranscurrido >= duracionPresentacion) {
    estadoActual = ESTADO_MENU;
  }
}
  
  void dibujarMenu() {
  background(20, 25, 45);
  
  fill(0, 255, 200);
  textSize(48);
  text("VOLT-X", width/2, height/2 - 80);
  
  fill(255);
  textSize(20);
  text("ESCAPE DE CHATARRA", width/2, height/2 - 30);
  
  fill(0, 180, 150);
  stroke(0, 255, 200);
  strokeWeight(2);
  rect(width/2 - 140, height/2 + 30, 280, 50, 10);
  
  fill(255);
  noStroke();
  textSize(18);
  text("PRESIONA ENTER PARA JUGAR", width/2, height/2 + 55);
}
  
  
  void dibujarPausa() {
  fill(0, 10); 
  rect(0, 0, width, height);
  fill(255);
  text("PAUSA\nPresiona 'P' para reanudar", width/2, height/2);
}

void dibujarVictoria() {
  background(50, 150, 50);
  fill(255);
  text("¡VICTORIA!\nMeta alcanzada.", width/2, height/2 - 60);
  
  textSize(24);
  text("Puntaje Total: " + puntajeTotalFinDeNivel, width/2, height/2 + 10);
  
  textSize(18);
  text("Presiona ENTER para volver al menú", width/2, height/2 + 70);
  textSize(32);
}

void dibujarDerrota() {
  background(150, 50, 50);
  fill(255);
  text("DERROTA\nBatería agotada o Caída crítica.\nPresiona ENTER para volver al menú", width/2, height/2);
}

}
