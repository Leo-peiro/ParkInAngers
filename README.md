# ParkInAngers


## version de Flutter/Dart utilisée

version ?? A COMPLÉTER

## fonctionnalités de l’application

L'objectif de notre application est de permettre à un utilisateur de localiser un parking à Angers autour de lui, et de connaître le nombre de places disponibles dans ce parking.

Notre application est basée sur un menu à trois boutons, le premier renvoie sur la page de garde, la carte. Le second affiche les parkings enregistrés comme favoris. Enfin, le troisième affiche la liste de tous les parkings d'Angers.

Lorsque l'utilisateur lance l'application, il se voit la carte s'afficher, il est ensuite géolocalisé et placé sur la carte. La map indique les différents parking de la ville d'Angers.

En cliquant sur les marqueurs rouges, les informations principales du parking choisi s'affichent dans un menu que doit dérouler l'utilisateur.

Dans la page des favoris, l'utilisateur peut voir ses parkings préférés ou alors, s'il n'y en a pas, des boutons sont disponibles pour actualiser ou ajouter un nouveau parking à cette liste.

En cliquant sur le bouton pour ajouter un parking au favoris, l'utilisateur est renvoyé vers la liste de tous les parkings d'Angers, ensuite, il doit cliquer sur un parking, puis cliquer sur le bouton favori (cœur).

Une fois ce processus effectué, si l'utilisateur retourne sur la page des favoris, il verra le ou les parkings choisis affichés.

## API utilisées

Deux API ont été utilisées dans ce projet : 

- Disponibilité dans les Parkings à Angers : https://data.angers.fr/explore/dataset/parking-angers/information/
- Angers stationnement : https://data.angers.fr/explore/dataset/angers_stationnement/information/

Les deux API sont complémentaires, la première affiche le nom du parking et le nombre de places disponibles alors que la deuxième met à disposition des données complémentaires, comme la localisation, le nombre de places total, les tarfis, les horaires ...
