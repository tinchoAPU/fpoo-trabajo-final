class NivelTilemap {
  int[][] mapa;
  int tamTile = 40; // Cada bloque mide 40x40 píxeles
  
  // Constructor: Recibe un arreglo bidimensional (el diseño del nivel)
  NivelTilemap(int[][] diseño) {
    this.mapa = diseño;
  }
  
  void dibujarSuelo(float camX) {
    int filas = mapa.length;
    int columnas = mapa[0].length;
    
    for (int fila = 0; fila < filas; fila++) {
      for (int col = 0; col < columnas; col++) {
        
        int tipoTile = mapa[fila][col];
        float posX = (col * tamTile) - camX;
        float posY = fila * tamTile;
        
        // Culling visual: Solo dibujamos si el bloque está dentro de la pantalla
        if (posX > -tamTile && posX < width) {
          
          switch(tipoTile) {
            case 1: // Piso sólido básico
              fill(100); 
              rect(posX, posY, tamTile, tamTile);
              break;
            case 2: // Suelo de Lava
              fill(255, 50, 0); 
              rect(posX, posY, tamTile, tamTile);
              break;
            case 3: // Plataforma elevada de metal
              fill(150, 150, 180); 
              rect(posX, posY, tamTile, tamTile);
              break;
          }
        }
      }
    }
  }

  // --- LÓGICA MATEMÁTICA RÁPIDA DE COLISIONES ---
  // Recibe un punto (ej. el centro de los pies del jugador) y devuelve true si está pisando un bloque sólido
  // Reemplaza el método chequearPisoSólido por este:
  boolean chequearPuntoSolido(float x, float y) {
    int col = int(x / tamTile);
    int fila = int(y / tamTile);
    
    if (fila >= 0 && fila < mapa.length && col >= 0 && col < mapa[0].length) {
      int tipo = mapa[fila][col];
      if (tipo == 1 || tipo == 3) {
        return true; 
      }
    }
    return false;
  }
  
  boolean tocandoLava(float x, float y) {
    int col = int(x / tamTile);
    int fila = int(y / tamTile);
    
    if (fila >= 0 && fila < mapa.length && col >= 0 && col < mapa[0].length) {
      if (mapa[fila][col] == 2) { // Si toca el bloque 2, está en la lava
        return true;
      }
    }
    return false;
  }
}
