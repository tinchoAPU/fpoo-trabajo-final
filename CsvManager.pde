class CsvManager{
int[][] cargarMapaCSV(String nombreArchivo) {
  String[] lineas = loadStrings(nombreArchivo);
  
  int filas = lineas.length;
  int columnas = split(lineas[0], ",").length; 
  
  int[][] mapaTemporal = new int[filas][columnas];

  for (int i = 0; i < filas; i++) {
    String[] valores = split(lineas[i], ",");
    for (int j = 0; j < columnas; j++) {
      mapaTemporal[i][j] = int(trim(valores[j])); 
    }
  }
  return mapaTemporal;
}
}
