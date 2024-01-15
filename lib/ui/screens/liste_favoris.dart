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
   List<Parking> parkings = [];
   List<String> parkingsNames = [];


  Future<void> fetchParkingData(List<String> parkingsNames) async {
    try {
      final List<Parking> parkingList = await parkingRepository.fetchParkingFromNames(parkingsNames);
      if (mounted) {
        setState(() {
          parkings = parkingList;
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }
  Future<void> loadFavoriteParkings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    parkingsNames = prefs.getStringList('favorites') ?? [];
  }
  Future<void> loadAndFetchParkings() async {
    await loadFavoriteParkings();
    await fetchParkingData(parkingsNames);
    setState(() {});

  }
  @override
  void initState() {
    super.initState();
    loadAndFetchParkings();

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des parkings favoris'),
      ),
      body: Container(
        child: parkings.isNotEmpty
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
      floatingActionButton: FloatingActionButton(
        onPressed: refresh,
        tooltip: 'Actualiser',
        child: const Icon(Icons.refresh),
      ),
    );
  }
  Widget buildParkingTile(Parking parking) {
    return ListTile(
      title: Text(parking.nom),
      subtitle: Row(
        children: [
          const Icon(Icons.local_parking_sharp, size: 24),
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
  Future<void> refresh() async {
    setState(() {});
    loadAndFetchParkings();
  }
}
