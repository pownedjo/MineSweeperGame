# MineSweeperGame
Basic Swift implementation of the famous Minesweeper Game.

## Installation
Cloner ou Télécharger le repo sur votre espace de travail et lancer le fichier MineSweeperGame.xcodeproj

## Fonctionnement
Une fois l'application lancé, l'utilisateur est invité à cliquer sur le boutton info pour prendre connaissance des régles du jeu. 
<br/>Avant de lancer le jeu (appui sur le boutton START), l'utilisateur peut sélectionner la difficulté (débutant par défaut) de la partie qu'il souhaite provoquer.
<br/>Le jeu propose 3 niveaux de difficulté qui permettent de faire varier la taille du plateau et le nombre de Mines sur celui-ci : 
<br/><br/>- Débutant : 10x10 (10 mines sur le plateau)
<br/>- Intermédiaire : 16x16 (40 mines sur le plateau)
<br/>- Difficile : 24x24 (99 mines sur le plateau)

<br/>
Une fois la partie lancé, l'utilisateur peut alors commencer à "déverouiller" des cellules en espérant ne pas déclencher une mine, ce qui arrêterait instantanément la partie.
<br/>Une partie peut se terminer de 3 façons distinctes : l'utilisateur choisi d'abandonner et appui sur STOP, l'utilisateur déclenche une mine ou l'utilisateur déverouilles toutes les cellules ne cotenant pas de mine.
<br/>Il est à noté qu'un niveau basique d'anglais est nécessaire pour jouer avec cette application, toutes les textes étant en Anglais...

## Architecture
L'application suit le pattern MVC, les classes <strong>Helpers</strong> servent seulement de support pour certaines méthodes.<br/>
<br/>Model : Les classes <strong>Grid</strong> (plateau de jeu) et <strong>Cell</strong> (cellule du plateau)
<br/>View : La classe <strong>CellButton</strong>, qui représente une Cellule avec laquelle l'utilisateur pourra interagir (Simple press & Long press)
<br/>Controller : La classe <strong>MainVC</strong> pour interfacer entre les classes Model et View énoncées ci-dessus.

## Points à améliorer
1. Interface Utilisateur. UI basique, je me suis servi de buttons pour représenter les Cellules, sur lesquels je mets à jour le title en fonction de l'état de la Cellule. Il est aussi à noté que je n'ai pas mis en place les contraintes de Layout pour supporter diverses tailles d'écran :(
2. Placement des Mines. La méthode de gestion du placement des mines dans <strong>Grid</strong> est à revoir pour respecter les régles du démineur. Il est aussi nécessaire de gérer plus efficacement le placement des mines pour ne pas avoir des parties trop faciles ou trop complexes.
3. MVC. Séparé la GameView de la classe <strong>MainVC</strong>  (éviter de tomber dans le Massive VC ici) et suivre au mieux les régles dicter par le pattern.

## Divers
Temps de développement : 8h 

## Credits
Jordan T.
