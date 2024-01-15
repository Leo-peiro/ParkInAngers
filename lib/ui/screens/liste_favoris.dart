import 'package:flutter/material.dart';
import 'package:park_in_angers/models/parking.dart';
import 'package:park_in_angers/repositories/parking_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListeFavoris extends StatefulWidget {
  const ListeFavoris({super.key});
  static List<Parking> parkings = [];
  @override
  State<ListeFavoris> createState() => _ListeFavorisState();
}

class _ListeFavorisState extends State<ListeFavoris> {
  final ParkingRepository parkingRepository = ParkingRepository();
  static List<Parking> parkings = [];
  static List<String> parkingsNames = [];

  Future<void> loadFavoriteParkings() async {
    print("loading favorites parkings from favorite widget");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    parkingsNames = prefs.getStringList('favorites') ?? [];
    print("liste des noms des parkings $parkingsNames");
  }

  Future<void> fetchParkingData(List<String> parkingsNames) async {
    try {
      final List<Parking> parkingList = await parkingRepository.fetchParkingFromNames(parkingsNames);
      setState(() {
        parkings = parkingList;
      });
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadFavoriteParkings();
    fetchParkingData(parkingsNames);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des parkings favoris'),
      ),
      body: Container(
        child: parkings.isNotEmpty // Vérifiez si la liste n'est pas vide
            ? ListView.builder(
          itemCount: parkings.length,
          itemBuilder: (context, index) {
            return buildParkingTile(parkings[index]);
          },
        )
            : const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
  Widget buildParkingTile(Parking parking) {
    return ListTile(
      title: Text(parking.nom),
      subtitle: Row(
        children: [
          const Icon(Icons.local_parking_sharp, size: 24), // Ajout de l'icône de voiture
          const SizedBox(width: 8),
          Text('Places disponibles: ${parking.npPlacesDisponiblesVoitures}'),
        ],
      ),
      // Ajoutez d'autres widgets pour afficher d'autres informations du parking
      onTap: () {
        Navigator.of(context).pushNamed(
          '/info_parking',
          arguments: parking,
        );

        // Ajoutez ici le code à exécuter lorsque l'utilisateur appuie sur la tuile
      },
    );
  }
}
