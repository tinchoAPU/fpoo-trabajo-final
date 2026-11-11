import processing.sound.*;

SoundFile sonidoBateria;
SoundFile sonidoPerderVida;
SoundFile musicaFondo;


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
float camX = 0;

int tiempoInicioPresentacion = 0;
int duracionPresentacion = 12000;
String historiaVoltX = "AÑO 2184. PLANETA CHATARRA.\n\nTu batería principal ha colapsado.\nRecupera celdas de energía y escapa\nantes de apagarte para siempre...";

Jugador miDron;
ArrayList<Enemigo> listaEnemigos = new ArrayList<Enemigo>();
NivelTilemap nivelActual;

ArrayList<Proyectil> listaProyectiles = new ArrayList<Proyectil>();
ArrayList<Item> listaItems = new ArrayList<Item>();

int puntajeActual = 0;
int puntajeTotalFinDeNivel = 0;

int vidas = 3;
int bateriasRecolectadas = 0;


PImage[] framesBateria;
int cantFramesBateria = 4;

ParallaxDrawer parallaxDrawer;
StateDrawer stateDrawer;
HudManager hudManager; 


// 0 = Vacío, 1 = Piso, 2 = Lava, 3 = Plataforma de Metal, 
// Entidades: 4 = Enemigo, 5 = Bláster, 6 = Batería, 8 = Baliza Victoria
int[][] disenoNivel1;

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  textSize(32);
  
  CsvManager csvManager = new CsvManager();
  parallaxDrawer = new ParallaxDrawer();
  stateDrawer = new StateDrawer();
  hudManager = new HudManager();
  
  PImage sheetBateria = loadImage("Battery.png");
  framesBateria = new PImage[cantFramesBateria];
  
  if (sheetBateria != null) {
    int anchoFrame = sheetBateria.width / cantFramesBateria;
    int altoFrame = sheetBateria.height;
    
    for (int i = 0; i < cantFramesBateria; i++) {
      framesBateria[i] = sheetBateria.get(i * anchoFrame, 0, anchoFrame, altoFrame);
    }
  }
  
  
  disenoNivel1 = csvManager.cargarMapaCSV("nivel1.csv");
  
  sonidoBateria = new SoundFile(this, "bateria.wav");
  sonidoPerderVida = new SoundFile(this, "dead.wav");
  musicaFondo = new SoundFile(this, "level_music.wav");
  
  nivelActual = new NivelTilemap(disenoNivel1);
  miDron = new Jugador(100, 100);
  
  tiempoInicioPresentacion = millis();
}

void draw() {                                                                                                    
  int tiempoActual = millis();
  deltaTime = (tiempoActual - tiempoAnterior) / 1000.0;
  tiempoAnterior = tiempoActual;
  
  switch (estadoActual) {
    case ESTADO_PRESENTACION: stateDrawer.dibujarPresentacion(); break;
    case ESTADO_MENU: stateDrawer.dibujarMenu(); break;
    case ESTADO_JUEGO: dibujarJuego(); break;
    case ESTADO_PAUSA: stateDrawer.dibujarPausa(); break;
    case ESTADO_VICTORIA: stateDrawer.dibujarVictoria(); break;
    case ESTADO_DERROTA: stateDrawer.dibujarDerrota(); break;
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
      else if (nivelActual.mapa[fila][col] == 7) listaItems.add(new Item(posX, posY, "BATERIA"));
      else if (nivelActual.mapa[fila][col] == 8) listaItems.add(new Item(posX, posY, "BALIZA"));
    }
  }
}

void activarVictoria() {
  int bonusBateria = (int)(miDron.bateria * 10); 
  puntajeTotalFinDeNivel = puntajeActual + bonusBateria;
  
  if (musicaFondo != null) musicaFondo.stop();
  estadoActual = ESTADO_VICTORIA;
}


void dibujarJuego() {
  parallaxDrawer.dibujarFondoParallax(camX);
  
  fill(0, 180);
  rect(0, 0, width, 40);
  
  hudManager.drawHud(puntajeActual, vidas, bateriasRecolectadas);
  
  float camaraDeseada = miDron.x - 200;
  if (camaraDeseada > camX) camX = camaraDeseada;
  
  nivelActual.dibujarSuelo(camX);

  miDron.actualizar(deltaTime, nivelActual, camX);
  miDron.dibujar(camX);
  
  for (int i = listaEnemigos.size() - 1; i >= 0; i--) {
    Enemigo e = listaEnemigos.get(i);
    
    if (e.x > camX - 100 && e.x < camX + width + 100) {
      e.actualizar(deltaTime, nivelActual);
      e.dibujar(camX);
      
      if (miDron.colisiona(e)) {
        miDron.recibirDanio(e.danio);
        listaEnemigos.remove(i);
      }
    }
  }
  
  for (int i = listaProyectiles.size() - 1; i >= 0; i--) {
    Proyectil p = listaProyectiles.get(i);
    p.actualizar(deltaTime, nivelActual);
    p.dibujar(camX);
    
    if (!p.activo || p.x > camX + width + 100 || p.x < camX - 100) {
      listaProyectiles.remove(i);
      continue; 
    }
    
    for (int j = listaEnemigos.size() - 1; j >= 0; j--) {
      Enemigo e = listaEnemigos.get(j);
      
      if (p.colisiona(e)) {
        listaEnemigos.remove(j);
        listaProyectiles.remove(i);
        puntajeActual += 100;
        break; 
      }
    }
  }
  
  for (int i = listaItems.size() - 1; i >= 0; i--) {
    Item item = listaItems.get(i);
    item.dibujar(camX);
    
    if (miDron.colisiona(item)) {
      if (item.tipo.equals("BLASTER")) {
        miDron.armaEquipada = item; 
      } 
      
      else if (item.tipo.equals("BATERIA")) {
        miDron.bateria += 20; 
        if (miDron.bateria > 100) miDron.bateria = 100;
        puntajeActual += 50;
        
        if (sonidoBateria != null) {
          sonidoBateria.play();
        }
        
        bateriasRecolectadas++;
        if (bateriasRecolectadas >= 10) {
          vidas++;
          bateriasRecolectadas = 0;
        }
      }
      else if (item.tipo.equals("BALIZA")) {
        activarVictoria();
      }
      
      listaItems.remove(i);
    }
  }
  
  if (miDron.bateria <= 0 || miDron.y > height + 100) {
    if (sonidoPerderVida != null) {
      sonidoPerderVida.play();
    }
    
    vidas--;
    if (vidas > 0) {
      miDron = new Jugador(100, 100);
      camX = 0;
      
      nivelActual = new NivelTilemap(disenoNivel1);
      cargarEntidades(); 
      
    } else {
      estadoActual = ESTADO_DERROTA;
    }
  }
}

// --- CONTROLES Y EVENTOS ---

void keyPressed() {
  if (estadoActual == ESTADO_PRESENTACION && keyCode == ENTER) {
    estadoActual = ESTADO_MENU;
  }
  else if (estadoActual == ESTADO_MENU && keyCode == ENTER) {
    puntajeActual = 0;
    vidas = 3;
    bateriasRecolectadas = 0;
    miDron = new Jugador(100, 100);
    camX = 0;
    
    nivelActual = new NivelTilemap(disenoNivel1); 
    cargarEntidades();
    
    if (musicaFondo != null && !musicaFondo.isPlaying()) {
      musicaFondo.loop(); 
    }
    
    estadoActual = ESTADO_JUEGO;
  }
  else if (estadoActual == ESTADO_JUEGO) {
    if (key == 'p' || key == 'P') estadoActual = ESTADO_PAUSA;
    
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
