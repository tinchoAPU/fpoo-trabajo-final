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
    if (tipo.equals("BLASTER")) {
      fill(255, 255, 0); // Amarillo para el arma
      rect(x - camX, y, ancho, alto);
      fill(0);
      textSize(16);
      text("A", x - camX + ancho/2, y + alto/2 - 2);
    } 
    else if (tipo.equals("HOVERBOARD")) {
      fill(200, 50, 255); // Violeta neón para la montura
      rect(x - camX, y, ancho, alto);
      fill(255);
      textSize(16);
      text("H", x - camX + ancho/2, y + alto/2 - 2);
    }
    
    else if (tipo.equals("BATERIA")) {
      fill(50, 255, 50); // Verde brillante
      rect(x - camX, y, ancho, alto);
      fill(0); textSize(16); text("+", x - camX + ancho/2, y + alto/2 - 2);
    }
    else if (tipo.equals("BALIZA")) {
      fill(255); // Blanco
      rect(x - camX, y, ancho, alto);
      fill(0); textSize(16); text("V", x - camX + ancho/2, y + alto/2 - 2);
    }
  }
}
