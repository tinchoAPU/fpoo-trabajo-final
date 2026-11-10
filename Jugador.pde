class Jugador extends Entidad {
  float bateria;
  float consumoBateria = 5.0;
  float gravedad = 1500.0;     // Aumentada para que caiga más rápido (se siente más pesado)
  float fuerzaSalto = -650.0;  // Impulso mayor para llegar a las plataformas altas
  float velMovimiento = 250.0;

  boolean enSuelo = false;
  boolean movIzquierda = false;
  boolean movDerecha = false;
  
  int direccionMirando = 1;
  float tiempoEntreDisparos = 0.3; // Segundos que debe esperar para volver a disparar
  float temporizadorDisparo = 0.0; //
  
  
  Item armaEquipada = null; // El espacio para tu Bláster
  Item montura = null;      // <--- EL ESPACIO PARA TU HOVERBOARD
  
  
  //ArrayList<Proyectil> listaProyectiles = new ArrayList<Proyectil>();

  Jugador(float x, float y) {
    super(x, y, 40, 40);
    this.bateria = 100.0;
  }

  void actualizar(float dt, NivelTilemap mapa, float camX) {
    
    temporizadorDisparo += dt;
    
    // --- 1. MOVIMIENTO HORIZONTAL Y COLISIÓN ---
    /*if (movIzquierda) velX = -velMovimiento;
    else if (movDerecha) velX = velMovimiento;
    else velX = 0;*/
    
    if (movIzquierda) {
      velX = -200.0;
      direccionMirando = -1; // Guarda que miramos a la izquierda
    } else if (movDerecha) {
      velX = 200.0;
      direccionMirando = 1;  // Guarda que miramos a la derecha
    } else {
      velX = 0;
    }
    

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
    
    
    if (this.montura != null) {
      fill(200, 50, 255); // Color violeta neón para el hoverboard
      rect(x - camX - 5, y + alto, ancho + 10, 8); // Un poco más ancho que el dron
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
    
    // Solo dispara si ya pasó el tiempo de recarga
    /*if (temporizadorDisparo >= tiempoEntreDisparos) {
      
      float origenX = x + (ancho / 2);
      float origenY = y + (alto / 2);
      
      listaProyectiles.add(new Proyectil(origenX, origenY, direccionMirando));
      
      // Reinicia el temporizador para aplicar el cooldown
      temporizadorDisparo = 0.0; 
    }*/
  }
  
  // Delegación de responsabilidades: El jugador decide cómo sufre el daño
  void recibirDanio(float cantidad) {
    if (this.montura != null) {
      // Tenemos el Hoverboard equipado. Absorbe el impacto y se destruye.
      this.montura = null; 
      // ¡No perdemos batería!
    } else {
      // No tenemos protección, perdemos batería directamente
      this.bateria -= cantidad;
    }
  }
}
