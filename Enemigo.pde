class Enemigo extends Entidad {
  float velocidadPatrulla = 100.0;
  float danio = 20.0;
  int direccion = -1;

  Enemigo(float x, float y) {
    super(x, y, 30, 30);
    velX = velocidadPatrulla * direccion;
  }
  
  void actualizar(float dt, NivelTilemap mapa) {
    velY += 1500.0 * dt; 
    y += velY * dt;

    if (velY > 0 && (mapa.chequearPuntoSolido(x, y + alto) || mapa.chequearPuntoSolido(x + ancho - 1, y + alto))) {
      y = (int)((y + alto) / mapa.tamTile) * mapa.tamTile - alto;
      velY = 0;
    }

    x += velX * dt;

    if (velX > 0) {
      boolean chocaPared = mapa.chequearPuntoSolido(x + ancho, y + alto/2);
      boolean hayPiso = mapa.chequearPuntoSolido(x + ancho, y + alto + 1);
      
      if (chocaPared || !hayPiso) {
        velX = -velocidadPatrulla;
        direccion = -1;
      }
    } 
    else if (velX < 0) {
      boolean chocaPared = mapa.chequearPuntoSolido(x, y + alto/2);
      boolean hayPiso = mapa.chequearPuntoSolido(x - 1, y + alto + 1);
      
      if (chocaPared || !hayPiso) {
        velX = velocidadPatrulla;
        direccion = 1;
      }
    }
  }

  void dibujar(float camX) {
    fill(255, 100, 0);
    rect(x - camX, y, ancho, alto);
    
    fill(255);
    rect(x - camX + (direccion == 1 ? 20 : 5), y + 5, 5, 5); 
  }
}
