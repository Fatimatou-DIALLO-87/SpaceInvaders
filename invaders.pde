class Invader 
{
  // Position sur l'ecran.
  PVector _position;
  // Position sur le plateau.
  int _cellX, _cellY;
  // Taille d'un envahisseur.
  float _size; 
  
  Invader(int cellX, int cellY, int size)
  {
     _cellX = cellX;
     _cellY = cellY;
     _size = size;
     
     _position = new PVector();
    
  }
  
  //Fonction qui dessine un envahisseur
  void drawIt(Board board, String file_invader)
  {
     _position = board.getCellCenter(_cellY, _cellX);
    
    PImage invader = loadImage(file_invader);
    invader.resize(board._cellSize - 5,board._cellSize - 5);
    imageMode(CENTER);
    image(invader, _position.x, _position.y); 
  }
  
  //Fonction qui vérifie si l'envahisseur atteint le bas du plateau
  boolean checkBottomCollisionInvader(Board board) {
      return _cellY >= board._nbCellsY - 1; // Bas du plateau
  }
  
}
