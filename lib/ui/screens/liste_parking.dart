import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:park_in_angers/models/parking.dart';
import 'package:park_in_angers/repositories/parking_repository.dart';
import 'dart:core';

import '../../composant/filter_parking.dart';

class ListeParking extends StatefulWidget {
  const ListeParking({Key? key}) : super(key: key);

  @override
  _ListeParkingState createState() => _ListeParkingState();
}

class _ListeParkingState extends State<ListeParking> {
  final ParkingRepository parkingRepository = ParkingRepository();
  late List<Parking> parkings = []; // Initialisez avec une liste vide
  late double latitude = 0;
  late double longitude = 0;

  @override
  void initState() {
    super.initState();
    _getDeviceLocation();
    fetchParkingData();
  }

  // Fonction pour récupérer les données et mettre à jour l'état
  Future<void> fetchParkingData() async {

    try {
      final List<Parking> parkingList = await parkingRepository.fetchAllParking();
      setState(() {
        parkings = trieParkingsParDistance(parkingList);
      });

    } catch (e) {
      // Gérez les erreurs ici
      print('Erreur lors de la récupération des données : $e');
    }
  }

  Future<void> _getDeviceLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      print(latitude);
      longitude = position.longitude;
      print(longitude);
    } catch (e) {
      print('Erreur lors de la récupération de la position : $e');
    }
  }

  // Pour avoir la distance entre deux points géographiques
  double calculeDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2)/ 1000;
  }

  //Trie les parkings en fonction de la distance
  List<Parking> trieParkingsParDistance(List<Parking> parkings) {
    parkings.sort((a, b) {
      double distanceA = calculeDistance(latitude, longitude, a.latitudeY!.toDouble() ?? 0, a.longitudeX!.toDouble() ?? 0);
      double distanceB = calculeDistance(latitude, longitude, b.latitudeY!.toDouble() ?? 0, b.longitudeX!.toDouble() ?? 0);
      return distanceA.compareTo(distanceB);
    });
    return parkings;
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
              onPressed: () async {
                final result = await showModalBottomSheet<Map<String, bool>>(
                  context: context,
                  builder: (BuildContext context) {
                    return const FilterSelectionParking();
                  },
                );
                if (result != null) {
                  bool checkBoxOuvert = result['checkBoxOuvert'] ?? false;
                  bool checkBoxDispo = result['checkBoxDispo'] ?? false;
                  bool checkBoxGratuit = result['checkBoxGratuit'] ?? false;

                  if(checkBoxDispo){
                    parkings.map((parking) => parking.npPlacesDisponiblesVoitures == 0? parkings.remove(parking):null);
                  }
                  if(checkBoxGratuit){

                  }
                  if(checkBoxOuvert){
                    parkings.map((parking) =>
                     parking.horaires?.heureOuverture != null && parking.horaires?.heureFermeture != null ?(
                        "${DateTime.now().hour}:${DateTime.now().minute}".compareTo(parking.horaires!.heureOuverture!) < 0
                        || "${DateTime.now().hour}:${DateTime.now().minute}".compareTo(parking.horaires!.heureFermeture!) > 0 ?(
                      parkings.remove(parking)):null):null);
                    //Gérer les fermetures exceptions et ouvertures exceptions
                  }

                  setState(() {

                  });
                }
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
      subtitle: Column(
        children: [
          Row(
            children: [
              Icon(Icons.local_parking_sharp, size: 24), // Ajout de l'icône de voiture
              SizedBox(width: 8),
              Text('Places disponibles: ${parking.npPlacesDisponiblesVoitures}'),
            ],
          ),
          Row(
            children: [
              Text(latitude!=0?'Se situe à  ${(calculeDistance(latitude, longitude, parking.latitudeY!.toDouble(),parking.longitudeX!.toDouble())).toStringAsFixed(3)}km de vous':'Problème de localisation'),
            ],
          ),
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