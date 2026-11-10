class Item extends Entidad {
  String tipo;

  Item(float x, float y, String tipo) {
    super(x, y, 20, 20); // Un cubo pequeño
    this.tipo = tipo;
  }

  void actualizar(float dt, NivelTilemap mapa) {
    // Si quisieras que el arma caiga por gravedad, lo harías aquí.
    // Por ahora, flota estática en el mapa.
  }

  void dibujar(float camX) {
    fill(255, 255, 0); // Color amarillo para que resalte
    rect(x - camX, y, ancho, alto);
    
    // Un pequeño detalle visual (una 'A' de Arma)
    fill(0);
    textSize(16);
    text("A", x - camX + ancho/2, y + alto/2 - 2);
  }
}
