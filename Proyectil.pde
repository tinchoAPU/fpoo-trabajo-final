class Proyectil extends Entidad {
  float velXDisparo = 500.0; // Velocidad súper rápida
  int direccion; // 1 = derecha, -1 = izquierda
  boolean activo = true; // Bandera para saber si chocó con una pared

  Proyectil(float x, float y, int dir) {
    super(x, y, 12, 4); // Un láser pequeño (12 de ancho x 4 de alto)
    this.direccion = dir;
    this.velX = velXDisparo * direccion;
    this.velY = 0; // Sin gravedad, viaja en línea recta
  }

  void actualizar(float dt, NivelTilemap mapa) {
    x += velX * dt;

    // Si toca una pared o el piso (bloques 1 o 3 del Tilemap), se desactiva
    if (mapa.chequearPuntoSolido(x + (direccion == 1 ? ancho : 0), y + alto/2)) {
      activo = false;
    }
  }

  void dibujar(float camX) {
    fill(0, 255, 255); // Color cyan/celeste láser
    rect(x - camX, y, ancho, alto);
  }
}
