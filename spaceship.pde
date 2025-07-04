class Spaceship {
  // Position on screen.
  PVector _position;
  // Position on board.
  int _cellX, _cellY;
  // Display size.
  float _size;

  ArrayList<Missile> _missiles; // Liste des missiles tirés par le vaisseau

  PImage damagedImage; // Image du vaisseau endommagé
  boolean isDamaged = false; // Indique si le vaisseau est endommagé

  int damageTimer = 0; // Temps restant avant de réinitialiser l'image

  Spaceship(int cellX, int cellY, float size) {
    _cellX = cellX;
    _cellY = cellY;
    _size = size;
    _position = new PVector();

    _missiles = new ArrayList<Missile>(); // Initialiser la liste


    damagedImage = loadImage("data/explosion.png"); // Image du vaisseau endommagé
    damagedImage.resize((int) _size, (int) _size);
  }

  //Fonction qui déssine le vaisseau et les missiles du vaisseau
  void drawSpaceshipAndTir(Board board) {
    _position = board.getCellCenter(_cellY, _cellX);

    //Desiner le vaisseau
    PImage vaisseauImage = isDamaged ? damagedImage : loadImage("data/player.png");
    vaisseauImage.resize(board._cellSize, board._cellSize);
    imageMode(CENTER);
    image(vaisseauImage, _position.x, _position.y);

    // Dessiner tous les missiles
    for (Missile m : _missiles) {
      m.drawMissile("data/player_tir.png");
    }
  }

  //Fonction qui vérifie si le vaisseau n'a pas dépassé les bords du plateau et fait la mise à jour de sa position
  void moveSpaceship(Board board, PVector dir) {
    int newCellX = _cellX + (int) dir.x;

    // Vérifie les limites du plateau
    if (newCellX >= 0 && newCellX < board._nbCellsX) {
      _cellX = newCellX;
    }

    // Mets à jour la position visuelle
    _position = board.getCellCenter(_cellY, _cellX);
  }

  //Fonction qui crée un missile à partir du vaisseau
  void CreateMissileSpaceship() {
    // Ajoute un nouveau missile partant du centre du vaisseau
    PVector startPosition = new PVector(_position.x, _position.y - _size / 2);
    _missiles.add(new Missile(startPosition, false));
  }

  //Fonction qui gère l'image du vaisseau et les missiles du vaisseau
  void updateSpaceshipAndTir(Board board) 
  {
    _position = board.getCellCenter(_cellY, _cellX);

    // Mettre à jour les missiles tiré par le vaisseau
    for (int i = _missiles.size() - 1; i >= 0; i--) 
    {
      Missile m = _missiles.get(i);
      m.updateTirVaisseau();
      if (m.isOutOfBoardTirSpaceship(board)) 
      {
        _missiles.remove(i); // Retirer les missiles hors du plateau
      }
    }

    // Réinitialiser l'image du vaisseau si le compteur de dommage atteint 0
    if (isDamaged && damageTimer > 0) 
    {
      damageTimer--;
    } 
    else if (isDamaged && damageTimer == 0) 
    {
      isDamaged = false;
    }
  }
}
