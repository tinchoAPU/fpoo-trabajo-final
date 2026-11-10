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
ArrayList<Enemigo> listaEnemigos = new ArrayList<Enemigo>();
NivelTilemap nivelActual;

ArrayList<Proyectil> listaProyectiles = new ArrayList<Proyectil>();
ArrayList<Item> listaItems = new ArrayList<Item>();

int puntajeActual = 0;
int puntajeTotalFinDeNivel = 0;

// --- DISEÑO DEL NIVEL (Matriz de 15 filas x 50 columnas) ---
// 0 = Vacío, 1 = Piso, 2 = Lava, 3 = Plataforma de Metal, 
// Entidades: 4 = Enemigo, 5 = Bláster, 6 = Hoverboard, 7 = Batería, 8 = Baliza Victoria
int[][] disenoNivel1 = {
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,5,4,7,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,0,0,0,4,4,0,0,4,8,0},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
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

void cargarEntidades() {
  listaEnemigos.clear(); 
  listaProyectiles.clear(); 
  listaItems.clear();
  
  for (int fila = 0; fila < nivelActual.mapa.length; fila++) {
    for (int col = 0; col < nivelActual.mapa[0].length; col++) {
      
      float posX = col * nivelActual.tamTile;
      float posY = fila * nivelActual.tamTile;
      
      if (nivelActual.mapa[fila][col] == 4) listaEnemigos.add(new Enemigo(posX, posY));
      else if (nivelActual.mapa[fila][col] == 5) listaItems.add(new Item(posX, posY, "BLASTER"));
      else if (nivelActual.mapa[fila][col] == 6) listaItems.add(new Item(posX, posY, "HOVERBOARD"));
      else if (nivelActual.mapa[fila][col] == 7) listaItems.add(new Item(posX, posY, "BATERIA"));
      else if (nivelActual.mapa[fila][col] == 8) listaItems.add(new Item(posX, posY, "BALIZA"));
    }
  }
}

void activarVictoria() {
  // Bono: Convertimos el % de batería restante en puntos (10 puntos por cada 1% de batería)
  int bonusBateria = (int)(miDron.bateria * 10); 
  puntajeTotalFinDeNivel = puntajeActual + bonusBateria;
  estadoActual = ESTADO_VICTORIA;
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
  if (camaraDeseada > camX) camX = camaraDeseada;
  
  // Dibujar mapa interactivo
  nivelActual.dibujarSuelo(camX);

  miDron.actualizar(deltaTime, nivelActual, camX);
  miDron.dibujar(camX);
  
  // --- ACTUALIZACIÓN DE ENEMIGOS Y COLISIONES ---
  for (int i = listaEnemigos.size() - 1; i >= 0; i--) {
    Enemigo e = listaEnemigos.get(i);
    
    // Culling: Solo procesamos enemigos cerca de la pantalla
    if (e.x > camX - 100 && e.x < camX + width + 100) {
      e.actualizar(deltaTime, nivelActual);
      e.dibujar(camX);
      
      if (miDron.colisiona(e)) {
        miDron.recibirDanio(e.danio); // Delegación de responsabilidad
        listaEnemigos.remove(i);      // El enemigo se destruye al impactar
      }
    }
  }
  
  // --- ACTUALIZACIÓN DE PROYECTILES ---
  for (int i = listaProyectiles.size() - 1; i >= 0; i--) {
    Proyectil p = listaProyectiles.get(i);
    p.actualizar(deltaTime, nivelActual);
    p.dibujar(camX);
    
    // 1. Verificar choques con mapa
    if (!p.activo || p.x > camX + width + 100 || p.x < camX - 100) {
      listaProyectiles.remove(i);
      continue; 
    }
    
    // 2. Verificar choques con enemigos
    for (int j = listaEnemigos.size() - 1; j >= 0; j--) {
      Enemigo e = listaEnemigos.get(j);
      
      if (p.colisiona(e)) {
        listaEnemigos.remove(j);    // Destruye al enemigo
        listaProyectiles.remove(i); // Destruye el láser
        puntajeActual += 100;       // Puntos por baja
        break; 
      }
    }
  }
  
  // --- ACTUALIZACIÓN DE ÍTEMS (Agregación, Dependencia y Meta) ---
  for (int i = listaItems.size() - 1; i >= 0; i--) {
    Item item = listaItems.get(i);
    item.dibujar(camX);
    
    if (miDron.colisiona(item)) {
      if (item.tipo.equals("BLASTER")) {
        miDron.armaEquipada = item; 
      } 
      else if (item.tipo.equals("HOVERBOARD")) {
        miDron.montura = item; 
      }
      else if (item.tipo.equals("BATERIA")) {
        miDron.bateria += 20; 
        if (miDron.bateria > 100) miDron.bateria = 100;
        puntajeActual += 50; 
      }
      else if (item.tipo.equals("BALIZA")) {
        activarVictoria();
      }
      
      listaItems.remove(i); // El objeto desaparece del mapa físico
    }
  }
  
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
  text("¡VICTORIA!\nBaliza alcanzada.", width/2, height/2 - 60);
  
  textSize(24);
  text("Puntaje Total: " + puntajeTotalFinDeNivel, width/2, height/2 + 10);
  
  textSize(18);
  text("Presiona ENTER para volver al menú", width/2, height/2 + 70);
  textSize(32); // Restauramos tamaño original
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
    // Al empezar, reiniciar variables de partida
    puntajeActual = 0;
    miDron = new Jugador(100, 100);
    camX = 0;
    
    nivelActual = new NivelTilemap(disenoNivel1); 
    cargarEntidades();
    
    estadoActual = ESTADO_JUEGO;
  }
  else if (estadoActual == ESTADO_JUEGO) {
    if (key == 'p' || key == 'P') estadoActual = ESTADO_PAUSA;
    if (key == 'v' || key == 'V') estadoActual = ESTADO_VICTORIA; 
    
    if (keyCode == LEFT || key == 'a' || key == 'A') miDron.movIzquierda = true;
    if (keyCode == RIGHT || key == 'd' || key == 'D') miDron.movDerecha = true;
    if (keyCode == UP || key == ' ') miDron.saltar();
    if (key == 'x' || key == 'X') miDron.disparar();
  }
  else if (estadoActual == ESTADO_PAUSA && (key == 'p' || key == 'P')) {
    estadoActual = ESTADO_JUEGO;
  }
  else if ((estadoActual == ESTADO_VICTORIA || estadoActual == ESTADO_DERROTA) && keyCode == ENTER) {
    estadoActual = ESTADO_MENU;
  }
}

void keyReleased() {
  if (estadoActual == ESTADO_JUEGO) {
    if (keyCode == LEFT || key == 'a' || key == 'A') miDron.movIzquierda = false;
    if (keyCode == RIGHT || key == 'd' || key == 'D') miDron.movDerecha = false;
  }
}
