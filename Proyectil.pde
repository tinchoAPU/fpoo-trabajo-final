class Proyectil extends Entidad {
  float velXDisparo = 500.0;
  int direccion;
  boolean activo = true;

  Proyectil(float x, float y, int dir) {
    super(x, y, 12, 4);
    this.direccion = dir;
    this.velX = velXDisparo * direccion;
    this.velY = 0;
  }

  void actualizar(float dt, NivelTilemap mapa) {
    x += velX * dt;

    if (mapa.chequearPuntoSolido(x + (direccion == 1 ? ancho : 0), y + alto/2)) {
      activo = false;
    }
  }

  void dibujar(float camX) {
    fill(0, 255, 255);
    rect(x - camX, y, ancho, alto);
  }
}
