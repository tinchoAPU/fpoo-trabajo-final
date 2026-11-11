class Item extends Entidad {
  String tipo;

  Item(float x, float y, String tipo) {
    super(x, y, 20, 20);
    this.tipo = tipo;
  }

  void dibujar(float camX) {
    if (tipo.equals("BLASTER")) {
      fill(255, 255, 0);
      rect(x - camX, y, ancho, alto);
      fill(0);
      textSize(16);
      text("A", x - camX + ancho/2, y + alto/2 - 2);
    } 
        
    else if (tipo.equals("BATERIA")) {
      fill(50, 255, 50);
      rect(x - camX, y, ancho, alto);
      fill(0); textSize(16); text("+", x - camX + ancho/2, y + alto/2 - 2);
    }
    else if (tipo.equals("BALIZA")) {
      fill(255);
      rect(x - camX, y, ancho, alto);
      fill(0); textSize(16); text("V", x - camX + ancho/2, y + alto/2 - 2);
    }
  }
}
