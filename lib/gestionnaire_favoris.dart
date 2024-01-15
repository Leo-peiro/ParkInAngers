import 'package:park_in_angers/ui/screens/liste_parking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:park_in_angers/models/parking.dart';

class FavoritesManager {
  static List<Parking> favoriteParkings = [];
  static Future<void> loadFavoriteParkings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    // print("reloading from gestionnaire favoris ... ");
    // Utiliser la liste des favoris pour extraire les parkings
    favoriteParkings = ListeParking.parkings.where((parking) => favorites.contains(parking.nom)).toList();
    print("favorites parkings depuis FavoritesManager : ");
    print(favoriteParkings);
  }

  static Future<void> toggleFavorite(Parking parking) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    print("favoris parkings depuis gestionnaire favories 1 : ");
    print(favorites);
    if (favorites.contains(parking.nom)) {
      favorites.remove(parking.nom);
    } else {
      favorites.add(parking.nom);
    }
    print("favoris parkings depuis gestionnaire favories 2 : ");
    print(favorites);
    await prefs.setStringList('favorites', favorites);
  }
}
