import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:park_in_angers/models/parking.dart';
import 'package:park_in_angers/repositories/parking_repository.dart';
import 'dart:core';
import 'package:park_in_angers/composant/filter_parking.dart';

class ListeParking extends StatefulWidget {
  const ListeParking({Key? key}) : super(key: key);
  static List<Parking> parkings = [];
  @override
  _ListeParkingState createState() => _ListeParkingState();
}

class _ListeParkingState extends State<ListeParking> {
  final ParkingRepository parkingRepository = ParkingRepository();
  late List<Parking> parkings = [];
  late List<Parking> parkingsFiltres = [];
  late double latitude = 0;
  late double longitude = 0;
  late bool checkBoxOuvert = false;
  late bool checkBoxDispo = false;
  late bool checkBoxGratuit = false;

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
        parkingsFiltres = parkings;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des données : $e');
      }
    }
  }

  Future<void> _getDeviceLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitude = position.longitude;
      setState(() {
        build(context);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération de la position : $e');
      }
    }
  }

  // Pour avoir la distance entre deux points géographiques
  double calculeDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2)/ 1000;
  }

  //Trie les parkings en fonction de la distance
  List<Parking> trieParkingsParDistance(List<Parking> parkings) {
    parkings.sort((a, b) {
      double distanceA = calculeDistance(latitude, longitude, a.latitudeY!.toDouble(), a.longitudeX!.toDouble());
      double distanceB = calculeDistance(latitude, longitude, b.latitudeY!.toDouble(), b.longitudeX!.toDouble());
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
                    return FilterSelectionParking(checkBoxOuvert: checkBoxOuvert, checkBoxDispo: checkBoxDispo, checkBoxGratuit: checkBoxGratuit);
                  },
                );
                if (result != null) {
                  checkBoxOuvert = result['checkBoxOuvert'] ?? false;
                  checkBoxDispo = result['checkBoxDispo'] ?? false;
                  checkBoxGratuit = result['checkBoxGratuit'] ?? false;

                  //Gestion des filtres
                  parkingsFiltres = parkings.where((parking) {
                    if (checkBoxDispo && parking.npPlacesDisponiblesVoitures == 0) {
                      return false;
                    }

                    if (checkBoxGratuit && parking.tarifs?.tarif1H != 0) {
                      return false;
                    }

                    //Il faut gérer les fermetures exceptions et ouvertures exceptions aussi
                    if (checkBoxOuvert && parking.horaires?.heureOuverture != null && parking.horaires?.heureFermeture != null) {
                      DateTime maintenant = DateTime.now();
                      List<String> horaireOuverture = parking.horaires!.heureOuverture!.split(":");
                      DateTime heuresOuverture = DateTime(maintenant.year, maintenant.month, maintenant.day, int.parse(horaireOuverture[0]), int.parse(horaireOuverture[1]));
                      List<String> horaireFermeture = parking.horaires!.heureFermeture!.split(":");
                      DateTime heuresFermeture = DateTime(maintenant.year, maintenant.month, maintenant.add(const Duration(days: 1)).day, int.parse(horaireFermeture[0]), int.parse(horaireFermeture[1]));
                      print(parking.horaires!.horairesException!.split(" ")[0]);
                      print(maintenant.weekday);

                      if (maintenant.isBefore(heuresOuverture) || maintenant.isAfter(heuresFermeture) ) {
                        return false;
                      }
                    }

                    return true;
                  }).toList();

                  setState(() {
                    build(context);
                  });
                }
              },
              child: const Text('Filtre'),
            ),
          ),
        ],
      ),
      body: Container(
        child: parkingsFiltres.isNotEmpty // Vérifie si la liste n'est pas vide
            ? ListView.builder(
          itemCount: parkingsFiltres.length,
          itemBuilder: (context, index) {
            return buildParkingTile(parkingsFiltres[index]);
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
              const Icon(Icons.local_parking_sharp, size: 24),
              const SizedBox(width: 8),
              Text('Places disponibles: ${parking.npPlacesDisponiblesVoitures}'),
            ],
          ),
          Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 32)),
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

String jourEnLettre(int numeroJour) {
  switch (numeroJour) {
    case 0:
      return "LUN";
    case 1:
      return "MAR";
    case 2:
      return "MER";
    case 3:
      return "JEU";
    case 4:
      return "VEN";
    case 5:
      return "SAM";
    case 6:
      return "DIM";
    default:
      return "Jour invalide";
  }
}