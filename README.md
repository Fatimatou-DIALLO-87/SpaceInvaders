# 👾 Space Invaders - Projet Java/Processing 2024

Ce projet est une réinterprétation du célèbre jeu **Space Invaders**, développée en **Processing** (Java). Le joueur contrôle un vaisseau spatial pour détruire les envahisseurs ennemis à l’aide de missiles, tout en évitant leurs tirs.

## 🧠 Fonctionnalités

- **Menus interactifs**. Le jeu commence par un menu d’accueil permettant de lancer une partie ou de quitter. Un écran de fin de partie s’affiche également après une défaite.

- **Vagues d’envahisseurs (ennemis)**. Les ennemis apparaissent en formation. Ils se déplacent de gauche à droite et descendent progressivement. Chaque vague devient plus rapide et plus difficile.

- **Effets d’explosion animés**. Lorsqu’un tir touche un ennemi, une animation d’explosion s’affiche. Cela rend le jeu plus dynamique et immersif.

- **Gestion des collisions**. Les missiles peuvent toucher les ennemis, le joueur ou les obstacles. Chaque collision déclenche une action : destruction, perte de vie, explosion.

- **Obstacles destructibles**. Des blocs de protection protègent temporairement le joueur. Ils se dégradent à chaque impact et finissent par disparaître.


# 🧱 Architecture du projet

Le projet est organisé de façon modulaire pour séparer clairement les différentes responsabilités du jeu.
| Dossier/Fichier             | Description                                             |
| --------------------------- | ------------------------------------------------------- |
| `space_invaders.pde`        | Point d’entrée principal du jeu (setup & draw)          |
| `game.pde`                  | Gestion de la logique de jeu, collisions, état général  |
| `menu.pde`                  | Affichage et interaction avec le menu de démarrage      |
| `spaceship.pde`             | Définition du joueur et de ses déplacements             |
| `invaders.pde`              | Gestion des envahisseurs ennemis                        |
| `missile.pde`               | Missiles du joueur et des ennemis                       |
| `explosion.pde`             | Gestion des animations d’explosions                     |
| `obstacle.pde`              | Blocs de protection destructibles                       |
| `board.pde`                 | Gestion du terrain de jeu et des limites                |
| `constants.pde`             | Constantes globales : vitesses, couleurs, tailles, etc. |
| `sketch.properties`         | Fichier de configuration propre à Processing            |
| `diallo_diallo_rapport.pdf` | Rapport de projet au format PDF                         |

📁 data/ — Ressources graphiques
| Fichier                   | Utilisation                                   |
| ------------------------- | --------------------------------------------- |
| `player.png`              | Sprite du vaisseau du joueur                  |
| `player_tir.png`          | Projectile tiré par le joueur                 |
| `invader_tir.png`         | Projectile des ennemis                        |
| `red_invader_1.png/2.png` | Sprites des envahisseurs rouges               |
| `explosion.png`           | Effet visuel d’explosion                      |
| `bloc.png`                | Bloc de protection                            |
| `image.jpg`               | Image utilisée pour fond ou menu (à vérifier) |


📁 levels/ — Fichiers de niveau
level1.txt : description textuelle de la première vague d’ennemis (format à préciser).

📁 score/ — Sauvegarde des scores
score.txt : contient les meilleurs scores ou le score actuel du joueur


# 🎮 Comment jouer
Lancer le fichier space_invaders.pde avec l’environnement Processing.

Appuyer sur la touche 1 pour démarrer une nouvelle partie.

Utiliser les flèches gauche et droite pour déplacer le vaisseau.

Appuyer sur espace pour tirer sur les ennemis.

Éliminer tous les envahisseurs sans se faire toucher pour gagner.

Appuyer sur Échap pour afficher le menu contextuel (pause ou retour au menu).

## 📦 Installation

1. Télécharger et installer [Processing](https://processing.org/download/).
2. Ouvrir le fichier `space_invaders.pde`.
3. Lancer le sketch (`Ctrl + R` ou bouton ▶️).

## 🖼️ Aperçu
# ![Fatimatou](https://github.com/Fatimatou-DIALLO-87/SpaceInvaders/blob/master/SpaceInvaders.gif)


## 🛠️ Technologies utilisées

-[Processing](https://processing.org)(langage Processing basé sur Java) à 100%
- Ressources graphiques en PNG





