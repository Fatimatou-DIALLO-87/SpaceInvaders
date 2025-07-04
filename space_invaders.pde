Game game;
Menu menu;


void setup() 
{
  size(800, 800, P2D);
  game = new Game();
  menu = new Menu();

}

void draw() 
{
  if (menu.isPlaying)
  {
    menu.drawItMenuMain(); //Affiche le menu principal
  }
  else
  {
    game.drawIt(); //Dessine le jeu

    if (menu.isFinish)
    {
      menu.drawItMenuGameOverWon(); //Affiche le menu de fin de jeu
    } 
    else if (menu.isVisible) 
    {
      menu.drawItMenuPopUp(); //Affiche le menu pop-up
    } 
    else if (menu.isViewingScores) 
    {
      menu.drawItMenuHighScores(); //Affiche le menu des scores
    } 
    else 
    {
      game.update(); 
    }
  }
}

void keyPressed() {

  // Si l'utilisateur consulte les scores, on ignore l'ESC
  if (menu.isViewingScores) 
  {
    // On ignore ESC ici et ne fait rien
    if (key == ESC) 
    {
      key = 0;
    }
    menu.handleInputScores(key);

    return; // Ne rien faire si une autre touche est pressée
  }
  if (key == ESC) 
  {
    menu.isVisible = !menu.isVisible; // Bascule la visibilité du menu
    key = 0; // Empêche le comportement par défaut d'ESC dans Processing
  }


  if (menu.isVisible) // Si le menu pop-up est visible
  {
    menu.handleInput(key); // Gère les entrées clavier pour le menu pop-up
  } 
  else if (menu.isPlaying) // Si le menu principal est visible
  {
    menu.handleInputMainMenu(key); // Gère les entrées pour le menu principal du jeu
  } 
  else if (menu.isFinish) // Si le jeu est terminé 
  {
    menu.handleInputMenuOverWon(key); // Gère les entrées pour le menu après une victoire/perte
  } 
  else
  {
    game.handleKey(keyCode); // Gère les entrées dans le jeu (Deplacement du vaisseau, tir du vaisseau)
  }
}

void keyReleased() {
  ismovin = false; //Si on rélache la touche SPACE 
}

void mousePressed() {
}
