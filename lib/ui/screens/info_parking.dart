import 'package:flutter/material.dart';
import 'package:park_in_angers/gestionnaire_favoris.dart';
import 'package:park_in_angers/models/parking.dart';
import 'package:park_in_angers/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoParking extends StatefulWidget {
  const InfoParking({Key? key}) : super(key: key);

  @override
  _InfoParkingState createState() => _InfoParkingState();
}

class _InfoParkingState extends State<InfoParking> {
  late Parking parking;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    // Récupérez les données du parking depuis les arguments
    parking = ModalRoute.of(context)!.settings.arguments as Parking;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations sur le parking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom du parking: ${parking.nom}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 16, color: Colors.grey),
            Text('Places disponibles: ${parking.npPlacesDisponiblesVoitures}'),
            const Divider(height: 16, color: Colors.grey),
            Text('Adresse : ${parking.adresse}'),
            const Divider(height: 16, color: Colors.grey),

            Visibility(
              visible: parking.horaires?.heureOuverture != null && parking.horaires?.heureFermeture != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_available_sharp, size: 24),
                      const SizedBox(width: 8),
                      Text('Heure ouverture : ${parking.horaires?.heureOuverture}'),
                    ],
                  ),
                    const Divider(height: 16, color: Colors.grey),
                    Row(
                      children: [
                        const Icon(Icons.event_busy_sharp, size: 24),
                        const SizedBox(width: 8),
                        Text('Heure fermeture : ${parking.horaires?.heureFermeture}'),
                      ],
                    ),
                ],
              ),
            ),
            Visibility(
              visible: parking.horaires?.heureOuverture == null && parking.horaires?.heureFermeture == null,
              child: const Row(
                children: [
                  Icon(Icons.event_available_sharp, size: 24),
                  // Icon(Icons.loop_sharp, size: 24),
                  SizedBox(width: 8),
                  Text('Accessible 24/24'),
                ],
              ),
            ),

            // ajouter une partie logique : si le parking fait parti des favoris => afficher bouton pour le supprimer des favoris; et l'inverse
            // const Divider(height: 16, color: Colors.grey),
            // ElevatedButton(onPressed:  () => addParkingToFavorites(parking), child: const Icon(Icons.add_location_alt_outlined, size: 35)),
            // const Divider(height: 16, color: Colors.grey),
            // ElevatedButton(onPressed: () => removeParkingFromFavorites(parking), child: const Icon(Icons.highlight_remove_sharp, size: 35)),
            ElevatedButton(
              onPressed: () {
                toggleFavorite();
              },
              child: isFavorite
                  ? const Icon(Icons.favorite, size: 35)
                  : const Icon(Icons.favorite_border, size: 35),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> toggleFavorite() async {
    await FavoritesManager.toggleFavorite(parking);
    await FavoritesManager.loadFavoriteParkings();
  }
  // Future<void> toggleFavorite() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> favorites = prefs.getStringList('favorites') ?? [];
  //
  //   print('Current favorites: $favorites');
  //
  //   if (isFavorite) {
  //     // Supprimer le parking des favoris
  //     favorites.remove(parking.nom);
  //     print('Removed ${parking.nom} from favorites');
  //   } else {
  //     // Ajouter le parking aux favoris
  //     favorites.add(parking.nom);
  //     print('Added ${parking.nom} to favorites');
  //   }
  //
  //   // Mettre à jour les préférences
  //   await prefs.setStringList('favorites', favorites);
  //
  //   // Mettre à jour l'état pour refléter le changement
  //   setState(() {
  //     isFavorite = !isFavorite;
  //   });
  //
  //   // Charger à nouveau les favoris
  //   await loadFavoriteParkings();
  // }
  // Future<void> toggleFavorite() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> favorites = prefs.getStringList('favorites') ?? [];
  //
  //   print('Current favorites: $favorites');
  //
  //   if (isFavorite) {
  //     // Si le parking est déjà en favori, supprimez-le
  //     favorites.remove(parking.nom);
  //     print('Removed ${parking.nom} from favorites');
  //   } else {
  //     // Sinon, ajoutez-le à la liste des favoris
  //     favorites.add(parking.nom);
  //     print('Added ${parking.nom} to favorites');
  //   }
  //
  //   // Mettez à jour les préférences
  //   await prefs.setStringList('favorites', favorites); // on ne peut que store des string ou num ou bool => store que l'id du parking puis mettre en place une fonction pour chercher de parking en question
  //
  //   // Mettez à jour l'état pour refléter le changement
  //   setState(() {
  //     isFavorite = !isFavorite;
  //   });
  // }

  //
  // Future<void> addParkingToFavorites(Parking parking) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final List<String> favoriteParkingList = prefs.getStringList('favoriteParkingList') ?? [];
  //
  //   // Vérifiez si le parking n'est pas déjà dans la liste des favoris
  //   if (!favoriteParkingList.contains(parking.nom)) {
  //     favoriteParkingList.add(parking.nom);
  //     prefs.setStringList('favoriteParkingList', favoriteParkingList);
  //     print('Parking ajouté aux favoris');
  //   } else {
  //     print('Le parking est déjà dans les favoris');
  //   }
  // }
  //
  // Future<void> removeParkingFromFavorites(Parking parking) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> favoriteParkingList = prefs.getStringList('favoriteParkingList') ?? [];
  //
  //   // Vérifiez si le parking est dans la liste des favoris
  //   if (favoriteParkingList.contains(parking.nom)) {
  //     favoriteParkingList.remove(parking.nom);
  //     prefs.setStringList('favoriteParkingList', favoriteParkingList);
  //     print('Parking supprimé des favoris');
  //   } else {
  //     print("Le parking n'est pas dans les favoris");
  //     }
  // }
}
