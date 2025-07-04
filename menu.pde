boolean affichage_scores = false;
PImage imageMenu;
boolean aff = true;

class Menu {
    boolean isVisible; // Indique si le menu pop-up est visible
    boolean isPlaying; // Indique si le jeu est en cours
    boolean isFinish;  // Indique si le jeu est terminé
    boolean isViewingScores; // Indique si l'utilisateur consulte les scores
     
    

    Menu() {
         
        isVisible = false; // Le menu pop-up est caché au démarrage
        isPlaying = true; // La partie jeu est caché au démarrage
        isFinish = false; // Le jeu n'est pas fini au début
        isViewingScores = false; // L'utilisateur ne consulte pas les scores au début
        
    }

    //Fonction qui affiche le menu pop-up
    void drawItMenuPopUp() {
        if (!isVisible || isViewingScores) return; // N'affiche pas si on consulte les scores

        // Fond du menu pop-up
        fill(50, 50, 50, 200); 
        rect(100, 100, width - 200, height - 200);

        // Titre du menu
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(32);
        text("MENU POP-UP", width / 2, 150);

        // Options du menu
        textSize(24);
        text("1. Reprendre la partie", width / 2, 250);
        text("2. Sauvegarder la partie", width / 2, 300);
        text("3. Charger une partie", width / 2, 350);
        text("4. Consulter les meilleurs scores", width / 2, 400);
        text("5. Quitter le jeu", width / 2, 450);

        // Instruction pour naviguer dans le menu
        textSize(16);
        text("Utilisez les touches 1-5 pour choisir une option", width / 2, height - 150);
        
    }
    
    //Fonction qui affiche le menu principal
    void drawItMenuMain() {
        
        background(0);

        imageMenu = loadImage("data/image.jpg");
        imageMenu.resize(350, 350);
        imageMode(CENTER);
        image(imageMenu, width/2, 200);

        // Options du menu
        textAlign(CENTER, CENTER);
        textSize(24);
        text("1. JOUER", width / 2, 450);
        text("2. Quitter le jeu", width / 2, 500);

        // Instruction pour naviguer dans le menu
        textSize(16);
        text("Utilisez les touches 1-2 pour choisir une option", width / 2, height - 150);
    }

    //Fonction qui affichage le menu après avoir gagné ou perdu
   void drawItMenuGameOverWon() {
        
        background(0);

       
        fill(255);
        textSize(32);
        textAlign(CENTER, CENTER);
        text("SPACE INVADERS", width / 2, 100);
        
        //Affichage du score
        textSize(30);
        text(affichageOverWon , width / 2, 250);
        text("Score : " + game._score, width / 2, 300);

        // Options du menu
        textSize(24);
        text("1. Rejouer", width / 2, 450);
        text("2. Quitter le jeu", width / 2, 500);

        // Instruction pour naviguer dans le menu
        textSize(16);
        text("Utilisez les touches 1-2 pour choisir une option", width / 2, height - 150);
    }
    
         //Fonction qui affiche le menu des meilleurs scores
    void drawItMenuHighScores() {
        if (!isViewingScores) return; // N'affiche pas si l'utilisateur ne consulte pas les scores

        // Fond du menu
        fill(50, 50, 50, 200); 
        rect(100, 100, width - 250, height - 250);

        // Titre du menu
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(32);
        text("MEILLEURS SCORES", width / 2, 150);

        // Affichage des scores
        String[] consulter_scores = loadStrings("score/score.txt");
        for (int i = 0; i < consulter_scores.length; i++) {
            textSize(24);
            text(consulter_scores[i], width / 2, 250 + i * 40);
        }

        // Option pour revenir au menu principal
        textSize(20);
        text("1. Retour au menu pop-up principal", width / 2, height - 200);
    }

    //Fonction qui gère les options sélectionnées au niveau du menu pop-up
    void handleInput(char key) {
        if (!isVisible) return;

        switch (key) {
            case '1': // Reprendre la partie
                isVisible = false; // Cache le menu
                break;

            case '2': // Sauvegarder la partie
                saveGame(); // Appel à la méthode de sauvegarde
                break;

            case '3': // Charger une partie
                loadGame(); // Appel à la méthode de chargement
                break;

            case '4': // Consulter les meilleurs scores
                isVisible = false;
                isViewingScores = true; // Affiche le menu des scores
                
                break;

            case '5': // Quitter le jeu
                exit(); // Quitte le jeu
                break;
        }
    }
    
    // Fonction qui gère les options sélectionnées au niveau du menu principal
    void handleInputMainMenu(char key) {

        switch (key) {
            case '1': // commencer la partie
                isPlaying = false; // Cache le menu
                break;
  
            case '2': // Quitter le jeu
                exit(); // Quitte le jeu
                break;
        }
    }
    
    // Fonction qui gère les options sélectionnées au niveau du menu fin de jeu
    void handleInputMenuOverWon(char key) {

        switch (key) {
            case '1': // reprendre la partie
                isFinish = false; // Cache le menu
                game = new Game();
                break;
  
            case '2': // Quitter le jeu
                exit(); // Quitte le jeu
                break;
        }
    }
    
    //Fonction qui gère les entrées pour le menu des scores
    void handleInputScores(char key) {
        if (!isViewingScores) return;

        if (key == '1') {
            isViewingScores = false; // Revient au menu principal
            isVisible = true;
        }
    }

  //Fonction qui sauvegarde une partie en cours
  void saveGame() 
  {
     println("Partie sauvergadee");
  }

   //Fonction qui charge une partie sauvegardée
   void loadGame() 
   {
      println("Partie chargee");  
   }
    
}
