class Jugador extends Entidad {
  float bateria;
  float consumoBateria = 5.0;
  float gravedad = 900.0;
  boolean enSuelo = false;

  Jugador(float x, float y) {
    super(x, y, 40, 40);
    this.bateria = 100.0;
  }

  void actualizar(float dt) {
    velY += gravedad * dt;
    super.actualizar(dt);

    bateria -= consumoBateria * dt;

    if (y + alto >= height - 20) {
      y = height - 20 - alto;
      velY = 0;
      enSuelo = true;
    } else {
      enSuelo = false;
    }
  }

  void saltar() {
    if (enSuelo) {
      velY = -450;
      enSuelo = false;
    }
  }

  void dibujar() {
    fill(0, 255, 0);
    rect(x, y, ancho, alto);
    
    fill(255, 0, 0);
    rect(x, y - 15, ancho, 5);
    fill(0, 255, 255);
    rect(x, y - 15, map(bateria, 0, 100, 0, ancho), 5);
  }
}
