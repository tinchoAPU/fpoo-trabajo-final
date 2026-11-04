// Constantes para la Máquina de Estados
final int ESTADO_PRESENTACION = 0;
final int ESTADO_MENU = 1;
final int ESTADO_JUEGO = 2;
final int ESTADO_PAUSA = 3;
final int ESTADO_VICTORIA = 4;
final int ESTADO_DERROTA = 5;

int estadoActual = ESTADO_PRESENTACION;

// Variables de tiempo (deltaTime)
int tiempoAnterior = 0;
float deltaTime = 0;

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  textSize(32);
}

void draw() {
  // Cálculo básico de deltaTime
  int tiempoActual = millis();
  deltaTime = (tiempoActual - tiempoAnterior) / 1000.0;
  tiempoAnterior = tiempoActual;

  // Máquina de estados principal
  switch (estadoActual) {
    case ESTADO_PRESENTACION:
      dibujarPresentacion();
      break;
    case ESTADO_MENU:
      dibujarMenu();
      break;
    case ESTADO_JUEGO:
      dibujarJuego();
      break;
    case ESTADO_PAUSA:
      dibujarPausa();
      break;
    case ESTADO_VICTORIA:
      dibujarVictoria();
      break;
    case ESTADO_DERROTA:
      dibujarDerrota();
      break;
  }
}

// --- MÉTODOS DE DIBUJO POR ESTADO (Greyboxing) ---

void dibujarPresentacion() {
  background(0);
  fill(255);
  text("Cinemática de Aterrizaje...\n(Presiona ENTER para continuar)", width/2, height/2);
}

void dibujarMenu() {
  background(50, 50, 150);
  fill(255);
  text("VOLT-X: ESCAPE DE CHATARRA\n\nPresiona ENTER para Jugar", width/2, height/2);
}

void dibujarJuego() {
  background(100, 200, 255); 
  fill(0);
  text("ESTADO: JUGANDO\nPresiona 'P' para Pausar\n'V' para Victoria | 'D' para Derrota", width/2, height/2);
}

void dibujarPausa() {
  // Rectángulo semitransparente para simular congelamiento
  fill(0, 10); 
  rect(0, 0, width, height);
  fill(255);
  text("PAUSA\nPresiona 'P' para reanudar", width/2, height/2);
}

void dibujarVictoria() {
  background(50, 150, 50);
  fill(255);
  text("¡VICTORIA!\nBaliza alcanzada.\nPresiona ENTER para volver al menú", width/2, height/2);
}

void dibujarDerrota() {
  background(150, 50, 50);
  fill(255);
  text("DERROTA\nBatería agotada.\nPresiona ENTER para volver al menú", width/2, height/2);
}

// --- CONTROL DE TRANSICIONES BÁSICAS ---

void keyPressed() {
  if (estadoActual == ESTADO_PRESENTACION && keyCode == ENTER) {
    estadoActual = ESTADO_MENU;
  }
  else if (estadoActual == ESTADO_MENU && keyCode == ENTER) {
    estadoActual = ESTADO_JUEGO;
    // Aquí llamaremos a cargarNivel() más adelante
  }
  else if (estadoActual == ESTADO_JUEGO) {
    if (key == 'p' || key == 'P') estadoActual = ESTADO_PAUSA;
    if (key == 'v' || key == 'V') estadoActual = ESTADO_VICTORIA; 
    if (key == 'd' || key == 'D') estadoActual = ESTADO_DERROTA;  
  }
  else if (estadoActual == ESTADO_PAUSA && (key == 'p' || key == 'P')) {
    estadoActual = ESTADO_JUEGO;
  }
  else if ((estadoActual == ESTADO_VICTORIA || estadoActual == ESTADO_DERROTA) && keyCode == ENTER) {
    estadoActual = ESTADO_MENU;
  }
}
