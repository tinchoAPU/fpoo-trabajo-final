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

Jugador miDron;
ArrayList<Enemigo> listaEnemigos = new ArrayList<Enemigo>();
NivelTilemap nivelActual;

ArrayList<Proyectil> listaProyectiles = new ArrayList<Proyectil>();
ArrayList<Item> listaItems = new ArrayList<Item>();

int puntajeActual = 0;
int puntajeTotalFinDeNivel = 0;

int vidas = 3;
int bateriasRecolectadas = 0;

PImage[] capasFondo = new PImage[8];
float[] velocidadesParallax = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8};

PImage imgPiedra;
PImage imgMagma;
PImage imgPlatform;
/*
PImage[] capasFondo = new PImage[4];
float[] velocidadesParallax = {0.1, 0.3, 0.5, 0.8}; 
*/


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
  
  imgPiedra = loadImage("piedra.png");
  imgMagma = loadImage("magma.png");
  imgPlatform = loadImage("platform.png");
  
  for (int i = 0; i < 8; i++) {
    capasFondo[i] = loadImage("Starry_night_Layer_" + i + ".png");
    if (capasFondo[i] != null) {
      capasFondo[i].resize(width, height); 
    }
  }
  
  
  sonidoBateria = new SoundFile(this, "bateria.wav");
  sonidoPerderVida = new SoundFile(this, "dead.wav");
  musicaFondo = new SoundFile(this, "level_music.wav");
  
  nivelActual = new NivelTilemap(disenoNivel1);
  miDron = new Jugador(100, 100);
}

void draw() {                                                                                                    
  int tiempoActual = millis();
  deltaTime = (tiempoActual - tiempoAnterior) / 1000.0;
  tiempoAnterior = tiempoActual;
  
  /*
  if (deltaTime > 0.05) {
    deltaTime = 0.05; 
  }*/
  
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
  int bonusBateria = (int)(miDron.bateria * 10); 
  puntajeTotalFinDeNivel = puntajeActual + bonusBateria;
  
  if (musicaFondo != null) musicaFondo.stop();
  estadoActual = ESTADO_VICTORIA;
}


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
  //background(20, 30, 60);
  
  dibujarFondoParallax(camX);
  
  fill(0, 180);
  rect(0, 0, width, 40);
  
  fill(255);
  textSize(16);
  textAlign(LEFT, CENTER);
  text("SCORE: " + nf(puntajeActual, 6), 30, 20);
  text("VIDAS: " + vidas, 320, 20);
  text("BATERÍAS: " + bateriasRecolectadas + "/10", 500, 20);
  textAlign(CENTER, CENTER);
  
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
      else if (item.tipo.equals("HOVERBOARD")) {
        miDron.montura = item; 
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
  textSize(32);
}

void dibujarDerrota() {
  background(150, 50, 50);
  fill(255);
  text("DERROTA\nBatería agotada o Caída crítica.\nPresiona ENTER para volver al menú", width/2, height/2);
}


//PRIMERO
/*void dibujarFondoParallax(float camaraX) {
  for (int i = 0; i < 4; i++) { // Bucle hasta 4
    if (capasFondo[i] == null) continue; 
    
    float posX = -(camaraX * velocidadesParallax[i]) % capasFondo[i].width;
    image(capasFondo[i], posX, 0); 
    image(capasFondo[i], posX + capasFondo[i].width, 0); 
  }
}*/

void dibujarFondoParallax(float camaraX) {
  for (int i = 0; i < 8; i++) {
    if (capasFondo[i] == null) continue; 
    
    // 1. Calculamos el desplazamiento absoluto en positivo
    // 2. Aplicamos el módulo respecto al ancho de la pantalla
    // 3. Lo convertimos a entero (int) para ahorrarle cálculos de píxeles intermedios a la CPU
    int desplazamientoX = (int)(camaraX * velocidadesParallax[i]) % width;
    
    // 4. Restamos para moverlo a la izquierda de forma segura
    int posX = -desplazamientoX;
    
    // Dibujamos usando la variable global 'width' en lugar de consultar el objeto de la imagen
    image(capasFondo[i], posX, 0); 
    image(capasFondo[i], posX + width, 0); 
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
