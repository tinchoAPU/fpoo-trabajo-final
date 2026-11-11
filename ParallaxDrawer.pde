class ParallaxDrawer{

  PImage[] capasFondo = new PImage[8];
  float[] velocidadesParallax = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8};
    
  ParallaxDrawer(){
    for (int i = 0; i < 8; i++) {
    capasFondo[i] = loadImage("Starry_night_Layer_" + i + ".png");
    if (capasFondo[i] != null) {
      capasFondo[i].resize(width, height); 
    }
  }
  }
  
  void dibujarFondoParallax(float camaraX) {
  for (int i = 0; i < 8; i++) {
    if (capasFondo[i] == null) continue; 
    
    int desplazamientoX = (int)(camaraX * velocidadesParallax[i]) % width;
    
    int posX = -desplazamientoX;
    
    image(capasFondo[i], posX, 0); 
    image(capasFondo[i], posX + width, 0); 
  }
}
}
