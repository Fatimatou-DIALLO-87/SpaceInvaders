class Missile {
  PVector _position; // Position actuelle du missile
  float _speed;      // Vitesse de déplacement du missile
  float _size;       // Taille visuelle du missile
  
  boolean isInvaderMissile; // Détermine si le missile est tiré par un envahisseur

  Missile(PVector startPosition, boolean isInvader) {
    _position = startPosition.copy();
    _speed = 10; 
    _size = 10; 
    
    isInvaderMissile = isInvader;
  }

  // Fonction qui fait la mise à jour de la position du missile tiré par le vaisseau
  void updateTirVaisseau() {
    _position.y -= _speed; // Déplacement vers le haut
  }
  
  // Fonction qui fait la mise à jour de la position du missile tiré par un envahisseur
  void updateTirInvader() {
    _position.y += _speed; // Déplacement vers le bas
  }

  // Fonction qui dessine le missile
  void drawMissile(String file_missile) {
    PImage missile = loadImage(file_missile);
    missile.resize(8, 12);
    imageMode(CENTER);
    image(missile, _position.x, _position.y); 
  }

  //Fonction qui vérifie si le missile tiré par le vaisseau est hors des limites du plateau
  boolean isOutOfBoardTirSpaceship(Board board) {
    // Vérifie si le missile est au-dessus du plateau
    return _position.y < board._position.y + board._cellSize;
  }
  
   //Fonction qui vérifie si le missile tiré par un envahisseur est hors des limites du plateau
  boolean isOutOfBoardTirInvader(Board board) {
    // Vérifie si le missile est en-dessous du plateau
    return _position.y > board._position.y + board._cellSize * board._nbCellsY;
  }
  
   //Fonction qui vérifie si le missile tiré par le vaisseau touche un envahisseur
  boolean checkCollisionTirSpaceshipWithInvader(Invader invader) {
    float distX = _position.x - invader._position.x;
    float distY = _position.y - invader._position.y;
    float distance = sqrt(distX * distX + distY * distY);
    
    return distance < (_size / 2 + invader._size / 2);
  }
  
  
  //Fonction qui vérifie si le missile tiré par le vaisseau touche un obstacle
 boolean checkCollisionTirSpaceshipWithObstacle(Obstacle obstacle) {
    float distX = _position.x - obstacle._position.x;
    float distY = _position.y - obstacle._position.y;
    float distance = sqrt(distX * distX + distY * distY);
    
    return distance < (_size / 2 + obstacle._size / 2);
  } 
  
  
  
  //Fonction qui vérifie si le missile tiré par un envahisseur touche le vaisseau
  boolean checkCollisionTirInvaderWithSpaceship(Spaceship spaceship) {
    float distX = _position.x - spaceship._position.x;
    float distY = _position.y - spaceship._position.y;
    float distance = sqrt(distX * distX + distY * distY);
    
    return distance < (_size / 2 + spaceship._size / 2);
  }
  
  //Fonction qui vérifie si un missile tiré par le vaisseau touche un missile tiré par un envahisseur
  boolean checkCollisionTirVaisseauAndTirInvader(Missile m)
  {
     
      float dx = _position.x - m._position.x;
      float dy = _position.y - m._position.y;
      float distance = sqrt(dx * dx + dy * dy);
            
      return distance < (_size / 2 + m._size / 2);
  }
  
}
