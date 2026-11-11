class Jugador extends Entidad {
  float bateria;
  float consumoBateria = 3.0;
  float gravedad = 1500.0;
  float fuerzaSalto = -650.0;
  float velMovimiento = 250.0;

  boolean enSuelo = false;
  boolean movIzquierda = false;
  boolean movDerecha = false;
  
  int direccionMirando = 1;
  float tiempoEntreDisparos = 0.3;
  float temporizadorDisparo = 0.0;
  
  
  Item armaEquipada = null;
  Item montura = null;
  

  Jugador(float x, float y) {
    super(x, y, 40, 40);
    this.bateria = 100.0;
  }

  void actualizar(float dt, NivelTilemap mapa, float camX) {
    
    temporizadorDisparo += dt;
    
    if (movIzquierda) {
      velX = -200.0;
      direccionMirando = -1;
    } else if (movDerecha) {
      velX = 200.0;
      direccionMirando = 1;
    } else {
      velX = 0;
    }
    

    x += velX * dt;

    if (x < camX) {
      x = camX;
      velX = 0;
    }

    if (velX > 0 && mapa.chequearPuntoSolido(x + ancho, y + alto/2)) {
      x = (int)((x + ancho) / mapa.tamTile) * mapa.tamTile - ancho;
      velX = 0;
    } else if (velX < 0 && mapa.chequearPuntoSolido(x, y + alto/2)) {
      x = (int)(x / mapa.tamTile) * mapa.tamTile + mapa.tamTile;
      velX = 0;
    }
  

    velY += gravedad * dt;
    y += velY * dt;

    enSuelo = false;
    
    if (mapa.tocandoLava(x + ancho/2, y + alto)) {
        bateria = 0;
    }
    
    if (velY > 0) { 
      if (mapa.chequearPuntoSolido(x, y + alto) || mapa.chequearPuntoSolido(x + ancho - 1, y + alto)) {
        y = (int)((y + alto) / mapa.tamTile) * mapa.tamTile - alto;
        velY = 0;
        enSuelo = true;
      }
    } else if (velY < 0) { 
      if (mapa.chequearPuntoSolido(x, y) || mapa.chequearPuntoSolido(x + ancho - 1, y)) {
        y = (int)(y / mapa.tamTile) * mapa.tamTile + mapa.tamTile;
        velY = 0;
      }
    }

    bateria -= consumoBateria * dt;
  }

  void saltar() {
    if (enSuelo) {
      velY = fuerzaSalto;
      enSuelo = false;
    }
  }

  void dibujar(float camX) {
    
    
    if (this.montura != null) {
      fill(200, 50, 255);
      rect(x - camX - 5, y + alto, ancho + 10, 8);
    }
    
    fill(0, 255, 0);
    rect(x - camX, y, ancho, alto);
    
    fill(255, 0, 0);
    rect(x - camX, y - 15, ancho, 5);
    fill(0, 255, 255);
    rect(x - camX, y - 15, map(bateria, 0, 100, 0, ancho), 5);
  }
  
  void disparar() {
    
    if (armaEquipada != null && temporizadorDisparo >= tiempoEntreDisparos) {
      
      float origenX = x + (ancho / 2);
      float origenY = y + (alto / 2);
      
      listaProyectiles.add(new Proyectil(origenX, origenY, direccionMirando));
      temporizadorDisparo = 0.0; 
    }
  }
  
  void recibirDanio(float cantidad) {
    if (this.montura != null) {
      this.montura = null; 
    } else {
      this.bateria -= cantidad;
    }
  }
}
