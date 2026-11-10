// --- VARIABLES GLOBALES ---
final int ESTADO_PRESENTACION = 0;
final int ESTADO_MENU = 1;
final int ESTADO_JUEGO = 2;
final int ESTADO_PAUSA = 3;
final int ESTADO_VICTORIA = 4;
final int ESTADO_DERROTA = 5;

int estadoActual = ESTADO_PRESENTACION;

int tiempoAnterior = 0;
float deltaTime = 0;
float camX = 0; // La cámara que sigue al jugador

Jugador miDron;
NivelTilemap nivelActual;

// --- DISEÑO DEL NIVEL (Matriz de 15 filas x 50 columnas) ---
// 0 = Vacío, 1 = Piso, 2 = Lava, 3 = Plataforma de Metal
int[][] disenoNivel1 = {
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, // Plataformas elevadas
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}, // El suelo (nótese el pozo y la lava)
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
};

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  textSize(32);
  
  nivelActual = new NivelTilemap(disenoNivel1);
  miDron = new Jugador(100, 100);
}

void draw() {                                                                                                        
  int tiempoActual = millis();
  deltaTime = (tiempoActual - tiempoAnterior) / 1000.0;
  tiempoAnterior = tiempoActual;

  switch (estadoActual) {
    case ESTADO_PRESENTACION: dibujarPresentacion(); break;
    case ESTADO_MENU: dibujarMenu(); break;
    case ESTADO_JUEGO: dibujarJuego(); break;
    case ESTADO_PAUSA: dibujarPausa(); break;
    case ESTADO_VICTORIA: dibujarVictoria(); break;
    case ESTADO_DERROTA: dibujarDerrota(); break;
  }
}

// --- MÉTODOS DE DIBUJO ---

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
  background(20, 30, 60); // Cielo nocturno
  
  // Lógica de avance continuo (La cámara no puede retroceder)
  float camaraDeseada = miDron.x - 200;
  if (camaraDeseada > camX) {
    camX = camaraDeseada;
  }
  
  // Dibujar mapa interactivo
  nivelActual.dibujarSuelo(camX);

  miDron.actualizar(deltaTime, nivelActual, camX);
  miDron.dibujar(camX);

  // Verificación de derrota (Batería cero o caída al vacío)
  if (miDron.bateria <= 0 || miDron.y > height + 100) {
    estadoActual = ESTADO_DERROTA;
  }
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
  text("¡VICTORIA!\nBaliza alcanzada.\nPresiona ENTER para volver al menú", width/2, height/2);
}

void dibujarDerrota() {
  background(150, 50, 50);
  fill(255);
  text("DERROTA\nBatería agotada o Caída crítica.\nPresiona ENTER para volver al menú", width/2, height/2);
}

// --- CONTROLES Y EVENTOS ---

void keyPressed() {
  if (estadoActual == ESTADO_PRESENTACION && keyCode == ENTER) {
    estadoActual = ESTADO_MENU;
  }
  else if (estadoActual == ESTADO_MENU && keyCode == ENTER) {
    // Al empezar, reiniciar personaje y cámara
    miDron = new Jugador(100, 100);
    camX = 0;
    estadoActual = ESTADO_JUEGO;
  }
  else if (estadoActual == ESTADO_JUEGO) {
    if (key == 'p' || key == 'P') estadoActual = ESTADO_PAUSA;
    if (key == 'v' || key == 'V') estadoActual = ESTADO_VICTORIA; 
    
    // Controles de movimiento
    if (keyCode == LEFT || key == 'a' || key == 'A') miDron.movIzquierda = true;
    if (keyCode == RIGHT || key == 'd' || key == 'D') miDron.movDerecha = true;
    if (keyCode == UP || key == ' ') miDron.saltar();
  }
  else if (estadoActual == ESTADO_PAUSA && (key == 'p' || key == 'P')) {
    estadoActual = ESTADO_JUEGO;
  }
  else if ((estadoActual == ESTADO_VICTORIA || estadoActual == ESTADO_DERROTA) && keyCode == ENTER) {
    estadoActual = ESTADO_MENU;
  }
}

// Se ejecuta al soltar la tecla para detener el dron fluidamente
void keyReleased() {
  if (estadoActual == ESTADO_JUEGO) {
    if (keyCode == LEFT || key == 'a' || key == 'A') miDron.movIzquierda = false;
    if (keyCode == RIGHT || key == 'd' || key == 'D') miDron.movDerecha = false;
  }
}
