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

  void dibujar(float camX) {
    fill(255);
    rect(x - camX, y, ancho, alto);
  }

  boolean colisiona(Entidad otra) {
    return (this.x < otra.x + otra.ancho &&
            this.x + this.ancho > otra.x &&
            this.y < otra.y + otra.alto &&
            this.y + this.alto > otra.y);
  }
}
