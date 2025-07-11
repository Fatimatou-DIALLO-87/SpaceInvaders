// An enum is a special "class" that represents a group of constants.
enum TypeCell
{
  EMPTY,
    SPACESHIP,
    INVADER,
    OBSTACLE
}

class Board
{
  TypeCell _cells[][];
  PVector _position;
  int _nbCellsX;
  int _nbCellsY;
  int _cellSize; // Cells should be square.

  Board(PVector pos, int nbX, int nbY, int size) {
    _position = pos.copy();
    _nbCellsX = nbX;
    _nbCellsY = nbY;
    _cellSize = size;
    _cells = new TypeCell[_nbCellsY][_nbCellsX];
  }

  //Fonction qui récupère le centre d'une cellule du plateau
  PVector getCellCenter(int i, int j) {
    return new PVector( _position.x + j * _cellSize + (_cellSize * 0.5),
      _position.y + i * _cellSize + (_cellSize * 0.5) );
  }

  //Fonction qui déssine le plateau du jeu
  void drawIt() {

    for (int i = 1; i < _nbCellsX; i++) {
      for (int j = 0; j < _nbCellsY; j++) {

        float x = _position.x + j * _cellSize;
        float y = _position.y + i * _cellSize;

        fill(20);
        noStroke();
        rect(x, y, _cellSize, _cellSize);
      }
    }
  }
}
