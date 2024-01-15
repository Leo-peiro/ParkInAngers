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
      if (mounted) {
        print("entrée setState de liste favoris");
        setState(() {
          parkings = parkingList;
        });
        print("sortie setState de liste favoris");
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }
  Future<void> loadAndFetchParkings(List<String> parkingsNames) async {
    await loadFavoriteParkings();
    await fetchParkingData(parkingsNames);
  }
  @override
  void initState() {
    super.initState();
    // loadFavoriteParkings();
    // fetchParkingData(parkingsNames);
    loadAndFetchParkings(parkingsNames);
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
      onTap: () {
        Navigator.of(context).pushNamed(
          '/info_parking',
          arguments: parking,
        );
      },
    );
  }
}
