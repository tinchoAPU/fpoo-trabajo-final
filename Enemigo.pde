class Enemigo extends Entidad {
  float velocidadPatrulla = 100.0;
  float danio = 20.0; // Cuánta batería te quita
  int direccion = -1; // -1 es izquierda, 1 es derecha

  Enemigo(float x, float y) {
    super(x, y, 30, 30); // Un poco más pequeño que el jugador (30x30)
    velX = velocidadPatrulla * direccion;
  }
  
  /*
  void actualizar(float dt, NivelTilemap mapa) {
    // 1. Gravedad para que camine sobre el piso
    velY += 1500.0 * dt; 
    y += velY * dt;

    if (velY > 0 && (mapa.chequearPuntoSolido(x, y + alto) || mapa.chequearPuntoSolido(x + ancho - 1, y + alto))) {
      y = (int)((y + alto) / mapa.tamTile) * mapa.tamTile - alto;
      velY = 0;
    }

    // 2. Movimiento horizontal
    x += velX * dt;

    // 3. Inteligencia Artificial básica (Patrullaje)
    // Si choca con una pared a la derecha, gira a la izquierda
    if (velX > 0 && mapa.chequearPuntoSolido(x + ancho, y + alto/2)) {
      velX = -velocidadPatrulla;
      direccion = -1;
    } 
    // Si choca con una pared a la izquierda, gira a la derecha
    else if (velX < 0 && mapa.chequearPuntoSolido(x, y + alto/2)) {
      velX = velocidadPatrulla;
      direccion = 1;
    }
  }
  */
  
  
  void actualizar(float dt, NivelTilemap mapa) {
    // 1. Gravedad para que camine sobre el piso
    velY += 1500.0 * dt; 
    y += velY * dt;

    if (velY > 0 && (mapa.chequearPuntoSolido(x, y + alto) || mapa.chequearPuntoSolido(x + ancho - 1, y + alto))) {
      y = (int)((y + alto) / mapa.tamTile) * mapa.tamTile - alto;
      velY = 0;
    }

    // 2. Movimiento horizontal
    x += velX * dt;

    // 3. Inteligencia Artificial mejorada (Patrullaje con detección de bordes)
    if (velX > 0) { // Caminando hacia la derecha
      boolean chocaPared = mapa.chequearPuntoSolido(x + ancho, y + alto/2);
      boolean hayPiso = mapa.chequearPuntoSolido(x + ancho, y + alto + 1); // Sensor abajo-derecha
      
      // Gira si se choca la cara o si se le acaba el piso
      if (chocaPared || !hayPiso) {
        velX = -velocidadPatrulla;
        direccion = -1;
      }
    } 
    else if (velX < 0) { // Caminando hacia la izquierda
      boolean chocaPared = mapa.chequearPuntoSolido(x, y + alto/2);
      boolean hayPiso = mapa.chequearPuntoSolido(x - 1, y + alto + 1); // Sensor abajo-izquierda
      
      // Gira si se choca la cara o si se le acaba el piso
      if (chocaPared || !hayPiso) {
        velX = velocidadPatrulla;
        direccion = 1;
      }
    }
  }

  void dibujar(float camX) {
    fill(255, 100, 0); // Color naranja/rojizo para peligro
    rect(x - camX, y, ancho, alto);
    
    // Un pequeño "ojo" robótico que mira hacia donde camina
    fill(255);
    rect(x - camX + (direccion == 1 ? 20 : 5), y + 5, 5, 5); 
  }
}
