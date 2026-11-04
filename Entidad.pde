class Entidad {
  float x, y;
  float ancho, alto;
  float velX, velY;

  Entidad(float x, float y, float ancho, float alto) {
    this.x = x;
    this.y = y;
    this.ancho = ancho;
    this.alto = alto;
    this.velX = 0;
    this.velY = 0;
  }

  void actualizar(float dt) {
    x += velX * dt;
    y += velY * dt;
  }

  void dibujar() {
    fill(255);
    rect(x, y, ancho, alto);
  }

  boolean colisiona(Entidad entidadEntidad) {
    return (this.x < entidadEntidad.x + entidadEntidad.ancho &&
            this.x + this.ancho > entidadEntidad.x &&
            this.y < entidadEntidad.y + entidadEntidad.alto &&
            this.y + this.alto > entidadEntidad.y);
  }
}
