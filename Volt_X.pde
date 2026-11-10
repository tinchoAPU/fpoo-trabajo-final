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

// --- DISEÑO DEL NIVEL (Matriz de 15 filas x 50 columnas) ---
// 0 = Vacío, 1 = Piso, 2 = Lava, 3 = Plataforma de Metal
int[][] disenoNivel1 = {
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, // Plataformas elevadas
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,5,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,0,0,0,4,4,0,0,4,0,0},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}, // El suelo (nótese el pozo y la lava)
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
};

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  textSize(32);
  
  nivelActual = new NivelTilemap(disenoNivel1);
  //cargarEntidades(); // Llamarla justo después de cargar el mapa
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
  listaEnemigos.clear(); // Limpiamos por si el jugador reinicia la partida
  
  for (int fila = 0; fila < nivelActual.mapa.length; fila++) {
    for (int col = 0; col < nivelActual.mapa[0].length; col++) {
      
      if (nivelActual.mapa[fila][col] == 4) {
        float posX = col * nivelActual.tamTile;
        float posY = fila * nivelActual.tamTile;
        
        // Creamos el objeto y lo guardamos en la colección
        listaEnemigos.add(new Enemigo(posX, posY));
        
        // ¡Magia! Borramos el 4 del mapa lógico (lo volvemos 0, aire)
        // porque el enemigo ya nació como objeto y no queremos que el mapa dibuje nada extraño ahí.
        //nivelActual.mapa[fila][col] = 0; 
      }
      
      if (nivelActual.mapa[fila][col] == 5) {
        float posX = col * nivelActual.tamTile;
        float posY = fila * nivelActual.tamTile;
        
        listaItems.add(new Item(posX, posY, "BLASTER"));
        // Borramos el 5 del mapa lógico (al igual que con el enemigo, si los dibujas por bloque)
        // nivelActual.mapa[fila][col] = 0; 
      }
    }
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
  
  // --- ACTUALIZACIÓN DE ENEMIGOS Y COLISIONES ---
  // Iteramos la lista de atrás hacia adelante para poder eliminar enemigos de forma segura
  for (int i = listaEnemigos.size() - 1; i >= 0; i--) {
    Enemigo e = listaEnemigos.get(i);
    
    // Solo actualizamos y dibujamos a los enemigos si están cerca de la pantalla (Culling)
    if (e.x > camX - 100 && e.x < camX + width + 100) {
      e.actualizar(deltaTime, nivelActual);
      e.dibujar(camX);
      
      // Detección de colisión usando el método heredado de la clase Entidad
      if (miDron.colisiona(e)) {
        miDron.bateria -= e.danio; // Sufrimos daño
        listaEnemigos.remove(i);   // El dron enemigo se destruye
      }
    }
  }
  
  // --- ACTUALIZACIÓN DE PROYECTILES ---
  for (int i = listaProyectiles.size() - 1; i >= 0; i--) {
    Proyectil p = listaProyectiles.get(i);
    p.actualizar(deltaTime, nivelActual);
    p.dibujar(camX);
    
    // 1. Si la bala chocó contra la pared, la borramos
    if (!p.activo || p.x > camX + width + 100 || p.x < camX - 100) {
      listaProyectiles.remove(i);
      continue; // Saltamos a la siguiente bala
    }
    
    // 2. Revisar si esta bala choca con algún enemigo
    for (int j = listaEnemigos.size() - 1; j >= 0; j--) {
      Enemigo e = listaEnemigos.get(j);
      
      if (p.colisiona(e)) {
        listaEnemigos.remove(j);    // Destruye al enemigo
        listaProyectiles.remove(i); // Destruye el láser
        break; // Sale del bucle de enemigos porque la bala ya no existe
      }
    }
  }
  
  // --- ACTUALIZACIÓN DE ÍTEMS (El Traspaso) ---
  for (int i = listaItems.size() - 1; i >= 0; i--) {
    Item item = listaItems.get(i);
    item.dibujar(camX);
    
    if (miDron.colisiona(item)) {
      if (item.tipo.equals("BLASTER")) {
        miDron.armaEquipada = item; // El jugador adquiere la referencia (Agregación)
      }
      listaItems.remove(i); // El ítem desaparece del suelo
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
    
    nivelActual = new NivelTilemap(disenoNivel1); 
    cargarEntidades();
    
    estadoActual = ESTADO_JUEGO;
  }
  else if (estadoActual == ESTADO_JUEGO) {
    if (key == 'p' || key == 'P') estadoActual = ESTADO_PAUSA;
    if (key == 'v' || key == 'V') estadoActual = ESTADO_VICTORIA; 
    
    // Controles de movimiento
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




// Se ejecuta al soltar la tecla para detener el dron fluidamente
void keyReleased() {
  if (estadoActual == ESTADO_JUEGO) {
    if (keyCode == LEFT || key == 'a' || key == 'A') miDron.movIzquierda = false;
    if (keyCode == RIGHT || key == 'd' || key == 'D') miDron.movDerecha = false;
  }
}
