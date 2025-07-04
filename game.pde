boolean ismovin; //Concerne le deplacement du vaisseau
PVector direction = new PVector(0, 0);
int time = 0; // Gère le temps de déplacement du vaisseau
int temps = 0; // Gère le temps de déplacement des envahisseurs
String affichageOverWon = "";


boolean modifyHighScores = false; // Pour gérer l'appel de la fonction de modification des 5 meilleurs scores


class Game
{
  Board _board;

  Spaceship _spaceship;

  ArrayList<Invader> _invaders; // Déclaration envahisseurs

  ArrayList<Obstacle> _obstacles; // Déclaration obstacles

  ArrayList<Missile> _invaderMissiles; // Déclaration missiles des envahisseurs

  ArrayList<Explosion> _explosions; //Déclaration explosions

  long lastInvaderShotTime = 0; // Pour contrôler le délai entre les tirs des envahisseurs


  String _levelName;
  int _lifes = START_LIFES;
  int _score;

  boolean _invaderMovingRight = true; // Direction du mouvement des envahisseurs (gauche/droite)

  boolean _gameOver = false; // Indique si le jeu est terminé avec gameOver
  boolean _gameWon = false; // Indique si le jeu est terminé avec success


  Game() {
    _score = 0;

    _invaders = new ArrayList<Invader>();  // Liste des envahisseurs

    _obstacles = new ArrayList<Obstacle>(); // Liste des obstacles

    _invaderMissiles = new ArrayList<Missile>(); // Liste des missiles des envahisseurs

    _explosions = new ArrayList<>(); // Liste des explosions


    // Pour determiner la taille du plateau
    int nbCel = 0, tailleCel;
    String[] file_level = loadStrings("levels/level1.txt");
    nbCel = file_level.length;
    
    tailleCel = min(width, height) / (nbCel + 1); //la taille des cellules du plateau

    //Création du plateau de jeu
    _board = new Board(new PVector((width - nbCel * tailleCel) / 2, (height - nbCel * tailleCel) / 2), nbCel, nbCel, tailleCel);
    loadBoard();

    //Créer le vaisseau
    createVaisseau();

    //créer les envahisseurs
    createInvaders();

    // Créer les obstacles
    createObstacles();
  }

  //Fonction qui dessine le jeu
  void drawIt() {
    background(0);

    // Dessiner le plateau de jeu et le vaisseau
    _board.drawIt();
    _spaceship.drawSpaceshipAndTir(_board);


    // Dessiner les envahisseurs
    for (Invader invader : _invaders) {
      invader.drawIt(_board, "data/red_invader_1.png");
    }

    // Dessiner les obstacles
    for (Obstacle obstacle : _obstacles) {
      obstacle.drawObstacle(_board);
    }

    // Dessiner les missiles des envahisseurs
    for (Missile missile : _invaderMissiles) {
      missile.drawMissile("data/invader_tir.png");
    }

    // Dessiner les explosions
    for (Explosion explosion : _explosions) {
      explosion.drawExplosion(_board);
    }


    // Afficher les vies et le score
    fill(255);
    textSize(20);
    text("LIVES: " + _lifes, 40, 30);
    text("SCORE: " + _score, width - 80, 30);


    //Gérer le jeu après avoir perdu
    if (_gameOver) {

      affichageOverWon = "Pas de chance ! vous avez perdu ";

      if (!modifyHighScores) 
      {
        //Modifie les meilleurs scores après avoir perdu
        ModifierMeilleursScores();
        modifyHighScores = true;
        
      }
      
      menu.isFinish = true; // met à true la variable qui permet que le menu de fin de jeu s'affiche
    }

    //Gérer le jeu après avoir gagné
    if (_gameWon) 
    { 
      affichageOverWon = "Félicitations ! vous avez gagné";

      if (!modifyHighScores) 
      {
         //Modifie les meilleurs scores après avoir gagné
        ModifierMeilleursScores();
        modifyHighScores = true;
        
      }
      
      menu.isFinish = true; // met à true la variable qui permet que le menu de fin de jeu s'affiche
    }
  }

  //Fonction qui modifie le jeu
  void update() {

    // Déplacer le vaisseau si les touches LEFT (ou Q ou q) ou RIGHT (ou D ou d) sont enfoncées
    if (ismovin)
    {
      if ( (millis() - time) > 50)
      {
        _spaceship.moveSpaceship(_board, direction);
        time = millis();
      }
    }

    //Deplacer les envahisseurs après 1000 ms
    if (millis() - temps > 1000)
    {
      updateInvaders();
      temps = millis();
    }

    // Mettre à jour le vaisseau (et les missiles tirés par le vaisseau)
    _spaceship.updateSpaceshipAndTir(_board);
    
    // Gérer les tirs des envahisseurs (Création)
    handleInvaderMissiles();
    
    // Mise à jour des missiles des envahisseurs
     updateMissilesInvaders();

    // Gérer les collisions entre missiles du vaisseau et envahisseurs
    handleMissileSpaceshipCollisionWithInvaders();

    // Gérer les collisions entre les missiles du vaisseau et obstacles
    handleMissileSpaceshipObstacleCollisions();


    // Gérer les collisions entre missiles d'envahisseurs et vaisseau
    handleInvaderMissileCollisionWithSpaceship();

    // Gérer les collisions entre missiles d'envahisseurs et obstacles
    handleInvaderMissileObstacleCollisions();
    
    //Gérer les collisions entre missiles vaisseau et missiles envahisseurs
    handleTirInvaderTirVaisseauCollision();

    // Vérifier si tous les envahisseurs ont été éliminés
    checkWinCondition();

    //Gérer les collisions entre missiles vaisseau et missiles envahisseurs
    handleTirInvaderTirVaisseauCollision();

    //Suppression d'explosion après 2 frames
    for (int i = _explosions.size() - 1; i >= 0; i--) {
      Explosion explosion = _explosions.get(i);
      explosion.update();
      if (explosion.isFinished()) {
        _explosions.remove(i);
      }
    }
  }

   //Fonction qui permet de charger le plateau de jeu dépuis un fichier
   void loadBoard() {
    String[] lignes = loadStrings("levels/level1.txt");

    for (int i = 1; i < lignes.length; i++) {

      for (int j = 0; j <  lignes[i].length(); j++) {

        char c = lignes[i].charAt(j);

        if ( c == 'E')
          _board._cells[i][j] = TypeCell.EMPTY;
        else if ( c == 'I')
          _board._cells[i][j] = TypeCell.INVADER;
        else if ( c == 'X')
          _board._cells[i][j] = TypeCell.OBSTACLE;
        else
          _board._cells[i][j] = TypeCell.SPACESHIP;
      }
    }
  }


  //Fonction qui gère le déplacement du vaisseau et les tirs du vaisseau
  void handleKey(int k) {
    
    if (k == LEFT || k=='Q' || k=='q') {
      direction = new PVector(-1, 0);
      ismovin = true;
    }

    if ( k == RIGHT || k=='D' || k=='d')
    {
      direction = new PVector(1, 0);
      ismovin = true;
    }

    // Si SPACE est pressé, tirer
    if (k == ' ') 
    {
      _spaceship.CreateMissileSpaceship(); 
    }
  }

  //Fonction pour créer le vaisseau
  void createVaisseau()
  {

    // Parcourir les cellules du plateau de jeu pour créer le vaisseau
    for (int i = 0; i < _board._nbCellsY; i++)
    {
      for (int j = 0; j < _board._nbCellsX; j++) 
      {
        // Si la cellule contient un vaisseau ('S'), créer un vaisseau
        if (_board._cells[i][j] == TypeCell.SPACESHIP) 
        {
          _spaceship = new Spaceship(j, i, _board._cellSize);
        }
      }
    }
    
  }

  //Fonction pour creer les obstacles
  void createObstacles() {
    
    // Parcourir les cellules du plateau de jeu pour créer les obstacles
    for (int i = 0; i < _board._nbCellsY; i++) 
    {
      for (int j = 0; j < _board._nbCellsX; j++) 
      {
        // Si la cellule contient un obstacle ('X'), créer un obstacle
        if (_board._cells[i][j] == TypeCell.OBSTACLE) 
        {
          _obstacles.add(new Obstacle(j, i, _board._cellSize));
        }
      }
    }
    
  }

  //Fonction pour creer les envahisseurs
  void createInvaders() {
    // Parcourir les cellules du tableau de jeu pour créer des envahisseurs
    for (int i = 0; i < _board._nbCellsY; i++) {
      for (int j = 0; j < _board._nbCellsX; j++) {
        // Si la cellule contient un envahisseur ('I'), créer un envahisseur
        if (_board._cells[i][j] == TypeCell.INVADER) {
          _invaders.add(new Invader(j, i, _board._cellSize));
        }
      }
    }
  }


  // Fonction pour mettre à jour le mouvement des envahisseurs
  void updateInvaders() {
    boolean edgeHit = false; // Pour vérifier si un envahisseur touche le bord gauche ou droit du plateau
    boolean toucheObstacleOrBordBottom = false; // Pour vérifier si un envahisseur touche un obstacle ou atteint le bord bas du plateau

    // Parcours de tous les envahisseurs
    for (Invader invader : _invaders) {
      
      //Vérifier si l'envahisseur touche le bord gauche ou droit du plateau
      if (invader._cellX == 0 || invader._cellX == _board._nbCellsX - 1) {
        edgeHit = true;
      }

      //verifier si l'envahisseur touche un obstacle
      if (checkObstacleCollisionWithInvaders(invader))
      {
        toucheObstacleOrBordBottom = true;
      }

      // Vérifier si l'envahisseur atteint le bord bas du plateau
      else if (invader.checkBottomCollisionInvader(_board)) 
      {
        toucheObstacleOrBordBottom = true;
      }
    }

    // Si un envahisseur touche le bord gauche ou droit du plateau, change la direction et descend
    if (edgeHit) {
      
      _invaderMovingRight = !_invaderMovingRight;
      
      for (Invader invader : _invaders) 
      {
        invader._cellY += 1;  // Descendre d'une case
      }
      
    }

    //Terminer le jeu si un envahisseur touche un obstacle ou le bord bas du plateau
    if (toucheObstacleOrBordBottom) {

      _gameOver = true; // Pour terminer le jeu 
      
    }

    // Déplacer les envahisseurs
    for (Invader invader : _invaders) {
      
      if (_invaderMovingRight && !checkObstacleCollisionWithInvaders(invader)) {
        invader._cellX += 1;  // Déplacement vers la droite
      } 
      else if (!checkObstacleCollisionWithInvaders(invader)) 
      {
        invader._cellX -= 1;  // Déplacement vers la gauche
      }
    }
  }

  // Fonction pour vérifier la collision entre un envahisseur et un obstacle
  boolean checkObstacleCollisionWithInvaders(Invader invader) {
    //Parcour tous les obstacles
    for (Obstacle obstacle : _obstacles) {
      if (obstacle._cellX == invader._cellX && obstacle._cellY == invader._cellY) {
        return true;  // L'envahisseur touche un obstacle
      }
    }
    return false;
  }

  //Fonction pour gérer les tirs des envahisseurs
  void handleInvaderMissiles() 
  {
    long currentTime = millis();

    for (Invader invader : _invaders) 
    {
      if (invader != null) 
      {
        // Si un envahisseur a tiré, on crée un missile
        if (currentTime - lastInvaderShotTime > 5000 && random(1) < 0.1) // 10% chance de tirer à chaque mise à jour
        { 
          //Recuperer la position où le missile doit être tiré
          PVector startPosition = new PVector(invader._position.x, invader._position.y + invader._size / 2);
          
          //Créer le missile
          _invaderMissiles.add(new Missile(startPosition, true)); // Le "true" indique qu'il s'agit d'un tir d'envahisseur
          
          lastInvaderShotTime = currentTime; // Réinitialiser le temps du dernier tir
          
          break;  // Un seul tir à la fois par envahisseur
        }
      }
    }
  }


  // Fonction pour mettre à jour les missiles des envahisseurs
  void updateMissilesInvaders()
  {
      // Parcourir tous les missiles des envahisseurs
      for (int i = _invaderMissiles.size() - 1; i >= 0; i--) 
      {
        
        Missile missile = _invaderMissiles.get(i);
        missile.updateTirInvader();  // Déplacer chaque missile vers le bas
        
        //Vérifier si le missile atteint le bord bas du plateau
        if (missile.isOutOfBoardTirSpaceship(_board)) 
        {
          _invaderMissiles.remove(i);  // Supprimer les missiles hors du plateau
        }
        
      }
  }

  //Fonction pour gérer les collisions entre les missiles du vaisseau et les envahisseurs
  void handleMissileSpaceshipCollisionWithInvaders() 
  {
    // Parcourir tous les missiles
    for (int i = 0; i < _spaceship._missiles.size(); i++) 
    {
      Missile missile = _spaceship._missiles.get(i);
      boolean missileDestroyed = false;

      // Parcourir les envahisseurs
      for (int j = _invaders.size() - 1; j >= 0; j--) 
      {
        Invader invader = _invaders.get(j);

        //Vérifier si l'envahisseur n'est pas nul et aussi vérifier qu'il y'a une collision entre missile vaisseau et envahisseur
        if (invader != null && missile.checkCollisionTirSpaceshipWithInvader(invader)) 
        {
          
          //Recuperer la position où il y'a eu collision
          PVector explosionPosition = new PVector((missile._position.x + invader._position.x) / 2,(missile._position.y + invader._position.y) / 2);

           //Ajouter une explosion 
          _explosions.add(new Explosion(explosionPosition, 2)); // Explosion pendant 2 frames

           // Supprimer l'envahisseur et le missile du vaisseau
          _invaders.remove(j);
          _spaceship._missiles.remove(i);
          
          _score += SCORE_KILL; // Incrementer le score

          missileDestroyed = true;
          break; // Sortir de la boucle dès qu'une collision est détectée
        }
      }

      // Si le missile a été détruit, on sort de la boucle
      if (missileDestroyed) 
      {
        break;
      }
      
    }
  }


  // Fonction pour gérer les collisions entre les missiles du vaisseau et les obstacles
  void handleMissileSpaceshipObstacleCollisions() 
  {
    // Parcourir les missiles du vaisseau
    for (int i = _spaceship._missiles.size() - 1; i >= 0; i--) 
    {
      Missile missile = _spaceship._missiles.get(i);

      // Parcourir les obstacles
      for (int j = _obstacles.size() - 1; j >= 0; j--) 
      {
        Obstacle obstacle = _obstacles.get(j);

        // Vérifier si l'obstacle est non null et que le missile touche l'obstacle
        if (obstacle != null && missile.checkCollisionTirSpaceshipWithObstacle(obstacle)) 
        {
           // Supprimer le missile du vaisseau et l'obstacle
          _obstacles.remove(j);
          _spaceship._missiles.remove(i);

          break; // Sortir de la boucle dès qu'une collision est traitée
        }
      }
    }
  }
 
  // Fonction pour gérer la collision entre les missiles d'envahisseurs et le vaisseau
  void handleInvaderMissileCollisionWithSpaceship() 
  {
    //Parcours les missiles des envahisseurs
    for (int i = _invaderMissiles.size() - 1; i >= 0; i--) 
    {
      Missile missile = _invaderMissiles.get(i);

      // Vérifier la collision entre le missile tiré par l'envahisseur avec le vaisseau
      if (missile.checkCollisionTirInvaderWithSpaceship(_spaceship)) 
      {
        // Réduire la vie du vaisseau
        _lifes--;

        _spaceship.isDamaged = true;
        _spaceship.damageTimer = 2; // 2 frames avant réinitialisation

        _invaderMissiles.remove(i);  // Supprimer le missile d'envahisseur

        // Si les vies du vaisseau atteignent 0
        if (_lifes <= 0) 
        {
          _gameOver = true;
        }
      }

      // Si le missile est sorti du plateau, le supprimer
      if (missile.isOutOfBoardTirInvader(_board)) 
      {
        _invaderMissiles.remove(i);
      }
    }
  }

  
  // Fonction pour gérer les collisions entre les missiles d'envahisseurs et les obstacles
  void handleInvaderMissileObstacleCollisions() 
  {
    //Parcourir les missiles d'envahisseurs
    for (int i = _invaderMissiles.size() - 1; i >= 0; i--)
    {
      Missile missile = _invaderMissiles.get(i);

      // Parcourir les obstacles
      for (int j = 0; j < _obstacles.size(); j++) 
      {
        Obstacle obstacle = _obstacles.get(j);

        // Vérifier si le missile touche l'obstacle
        if (missile.checkCollisionTirSpaceshipWithObstacle(obstacle)) 
        { 
          // Supprimer le missile et l'obstacle
          _invaderMissiles.remove(i);
          _obstacles.remove(j);

          // Sortir de la boucle dès que le missile est supprimé
          break;
        }
      }
    }
  }

  //Fonction pour gérer les collisions entre tir vaisseau et tir envahisseur
  void handleTirInvaderTirVaisseauCollision()
  {
    //Parcourir les missiles des envahisseurs
    for (int i = _invaderMissiles.size() - 1; i >= 0; i--)
    {
      Missile mInv = _invaderMissiles.get(i);

      //Parcourir les missiles du vaisseau
      for (int j =_spaceship._missiles.size() - 1; j >= 0; j--)
      {
        Missile mVaisseau = _spaceship._missiles.get(j);

        //Verifier si y'a collision
        if (mInv.checkCollisionTirVaisseauAndTirInvader(mVaisseau))
        {
          //Recupérer la position où il y'a eu collision
          PVector explosionPosition = new PVector( (mVaisseau._position.x + mInv._position.x) / 2,(mVaisseau._position.y + mInv._position.y) / 2);

           //Ajouter une explosion
           
          _explosions.add(new Explosion(explosionPosition, 2)); // Explosion pendant 2 frames
          
          //Supprimer le missile du vaisseau et le missile de l'envahisseur
          _invaderMissiles.remove(i);
          _spaceship._missiles.remove(j);

          break; //Sortir de la boucle si le missile est supprimé
        }
      }
    }
  }

  //-------------------------------------------GAGNE PARTIE-------------------------------------------
  // Vérifier si tous les envahisseurs ont été éliminés
  void checkWinCondition() {
    if (_invaders.size() == 0) {
      _gameWon = true;
    }
  }

  //-----------------------------------------MEILLEURS SCORES-----------------------------------------
  //Fonction qui modifie les meilleurs scores dans le fichier
  void ModifierMeilleursScores()
  {
    //Recuperation du contenu du fichier
    String[] scores = loadStrings("score/score.txt");

    int[] highScores= new int[5]; 

    //Rendre le tableau de String en tableau d'entier
    for (int i = 0; i < 5; i++)
    {
      highScores[i] = Integer.parseInt(scores[i]);  
    }

    highScores = sort(highScores); //Trier le tableau

    //Vérifier si le score actuel est supérieur au minimum des meilleurs scores
    if (_score > highScores[0])
    {
        highScores[0] = _score; //Le minimum des meilleurs scores récupère le score actuel
    }

    highScores = sort(highScores); //Trier à nouveau le tableau

    String[] scores_mod = new String[5];

    //Rendre le tableau d'entiers en tableau de String
    for (int i = 0; i < highScores.length; i++)
    {
      scores_mod[i] = Integer.toString(highScores[i]); 
    }

    //Modifier le contenu du fichier
    saveStrings("score/score.txt", scores_mod);
  }
}
