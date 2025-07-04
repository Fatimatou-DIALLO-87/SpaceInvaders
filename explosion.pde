class Explosion {
  PVector _position;
  int _duration;

  Explosion(PVector position, int duration) {
    _position = position.copy();
    _duration = duration;
  }

  //Fonction qui dessine une explosion
  void drawExplosion(Board board) {
    PImage explosionImage = loadImage("data/explosion.png");
    explosionImage.resize(board._cellSize - 3, board._cellSize - 3);
    imageMode(CENTER);
    image(explosionImage, _position.x, _position.y);
    
    
  }

  //Fonction qui vérifie si la durée de l'explosion est à 0
  boolean isFinished() {
    return _duration <= 0;
  }

  //Fonction qui décroit la durée de l'explosion
  void update() {
    _duration--; // Réduire la durée
  }
}
