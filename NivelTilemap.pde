class NivelTilemap {
  int[][] mapa;
  int tamTile = 40;
  
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
        
        if (posX > -tamTile && posX < width) {
          
          switch(tipoTile) {
            case 1:
              image(imgPiedra, posX, posY, tamTile, tamTile);
              /*fill(100); 
              rect(posX, posY, tamTile, tamTile);*/
              break;
            case 2:
              image(imgMagma, posX, posY, tamTile, tamTile);
              /*fill(255, 50, 0); 
              rect(posX, posY, tamTile, tamTile);*/
              break;
            case 3:
              image(imgPlatform, posX, posY, tamTile, tamTile);
              /*fill(150, 150, 180);
              rect(posX, posY, tamTile, tamTile);*/
              break;
          }
        }
      }
    }
  }

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
      if (mapa[fila][col] == 2) {
        return true;
      }
    }
    return false;
  }
}
