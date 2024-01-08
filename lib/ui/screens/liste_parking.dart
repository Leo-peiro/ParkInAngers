import 'package:flutter/material.dart';
import 'package:park_in_angers/models/parking.dart';
import 'package:park_in_angers/repositories/parking_repository.dart';

import '../../composant/filter_parking.dart';

class ListeParking extends StatefulWidget {
  const ListeParking({Key? key}) : super(key: key);

  @override
  _ListeParkingState createState() => _ListeParkingState();
}

class _ListeParkingState extends State<ListeParking> {
  final ParkingRepository parkingRepository = ParkingRepository();
  late List<Parking> parkings = []; // Initialisez avec une liste vide

  @override
  void initState() {
    super.initState();
    fetchParkingData();
  }

  // Fonction pour récupérer les données et mettre à jour l'état
  Future<void> fetchParkingData() async {
    try {
      final List<Parking> parkingList = await parkingRepository.fetchAllParking();
      setState(() {
        parkings = parkingList;
      });
    } catch (e) {
      // Gérez les erreurs ici
      print('Erreur lors de la récupération des données : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des parkings'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 46.0),
            //Création du bouton filtre
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const FilterSelectionParking();
                  },
                );
              },
              child: const Text('Filtre'),
            ),
          ),
        ],
      ),
      body: Container(
        child: parkings.isNotEmpty // Vérifie si la liste n'est pas vide
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
          Icon(Icons.local_parking_sharp, size: 24), // Ajout de l'icône de voiture
          SizedBox(width: 8),
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