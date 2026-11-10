class Jugador extends Entidad {
  float bateria;
  float consumoBateria = 5.0;
  float gravedad = 1500.0;     // Aumentada para que caiga más rápido (se siente más pesado)
  float fuerzaSalto = -650.0;  // Impulso mayor para llegar a las plataformas altas
  float velMovimiento = 250.0;

  boolean enSuelo = false;
  boolean movIzquierda = false;
  boolean movDerecha = false;

  Jugador(float x, float y) {
    super(x, y, 40, 40);
    this.bateria = 100.0;
  }

  void actualizar(float dt, NivelTilemap mapa, float camX) {
    // --- 1. MOVIMIENTO HORIZONTAL Y COLISIÓN ---
    if (movIzquierda) velX = -velMovimiento;
    else if (movDerecha) velX = velMovimiento;
    else velX = 0;

    x += velX * dt; // Movemos temporalmente en X

    // Chequeo de Muro Invisible (Borde izquierdo de la cámara)
    if (x < camX) {
      x = camX;
      velX = 0;
    }

    // Colisión Horizontal con el Tilemap (Chequeamos el centro-derecha y centro-izquierda)
    if (velX > 0 && mapa.chequearPuntoSolido(x + ancho, y + alto/2)) { // Choca por derecha
      x = (int)((x + ancho) / mapa.tamTile) * mapa.tamTile - ancho;
      velX = 0;
    } else if (velX < 0 && mapa.chequearPuntoSolido(x, y + alto/2)) { // Choca por izquierda
      x = (int)(x / mapa.tamTile) * mapa.tamTile + mapa.tamTile;
      velX = 0;
    }
  
  
    

    // --- 2. MOVIMIENTO VERTICAL Y COLISIÓN ---
    velY += gravedad * dt;
    y += velY * dt; // Movemos temporalmente en Y

    enSuelo = false;
    
    if (mapa.tocandoLava(x + ancho/2, y + alto)) {
        bateria = 0; // Muerte instantánea
    }
    
    if (velY > 0) { 
      // CAYENDO: Chequeamos los pies (Esquina inferior izquierda e inferior derecha)
      if (mapa.chequearPuntoSolido(x, y + alto) || mapa.chequearPuntoSolido(x + ancho - 1, y + alto)) {
        y = (int)((y + alto) / mapa.tamTile) * mapa.tamTile - alto;
        velY = 0;
        enSuelo = true;
      }
    } else if (velY < 0) { 
      // SALTANDO (Hacia arriba): Chequeamos la cabeza (Esquina superior izquierda y superior derecha)
      if (mapa.chequearPuntoSolido(x, y) || mapa.chequearPuntoSolido(x + ancho - 1, y)) {
        y = (int)(y / mapa.tamTile) * mapa.tamTile + mapa.tamTile;
        velY = 0; // Se golpea la cabeza y empieza a caer
      }
    }
    
    /*if (mapa.tocandoLava(x + ancho/2, y + alto)) {
        bateria = 0; // Muerte instantánea
    }*/

    // --- 3. CONSUMO DE BATERÍA ---
    bateria -= consumoBateria * dt;
  }

  void saltar() {
    if (enSuelo) {
      velY = fuerzaSalto;
      enSuelo = false;
    }
  }

  void dibujar(float camX) {
    fill(0, 255, 0);
    rect(x - camX, y, ancho, alto);
    
    fill(255, 0, 0);
    rect(x - camX, y - 15, ancho, 5);
    fill(0, 255, 255);
    rect(x - camX, y - 15, map(bateria, 0, 100, 0, ancho), 5);
  }
}
