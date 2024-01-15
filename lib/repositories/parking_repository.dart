import 'package:park_in_angers/models/horaires.dart';
import 'package:park_in_angers/models/parking.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:park_in_angers/models/tarifs.dart';

class ParkingRepository {

  Future<List<Parking>> fetchParkingFromNames(List<String> parkingsNames) async {
    final List<Parking> listeParkingFinale = [];
    for(String nomParking in parkingsNames){
      try{
        final Response response = await get(Uri.parse('https://data.angers.fr/api/explore/v2.1/catalog/datasets/parking-angers/records?where=nom="$nomParking"&limit=20'));
        if (response.statusCode == 200) {
          final Response response2 = await get(Uri.parse('https://data.angers.fr/api/explore/v2.1/catalog/datasets/angers_stationnement/records?where=id_parking="$nomParking"&limit=20'));
          final Map<String, dynamic> json = jsonDecode(response.body);
          if (json.containsKey("results")) {
            final List<dynamic> features = json['results'];
            for (Map<String, dynamic> feature in features) {
              final parking = Parking.fromJson(feature);
              if (response2.statusCode == 200) {
                final Map<String, dynamic> json2 = jsonDecode(response2.body);
                if (json2.containsKey("results")) {
                  final List<dynamic> features2 = json2['results'];
                  for (Map<String, dynamic> feature2 in features2) {
                    final Tarifs tarifs = Tarifs(
                      feature2['tarif_1h'],
                      feature2['tarif_2h'],
                      feature2['tarif_3h'],
                      feature2['tarif_4h'],
                      feature2['tarif_24h'],
                    );

                    final Horaires horaires = Horaires(
                      feature2['accessibilite'] == '24-24' ? true : false,
                      feature2['horaires_ouverture'],
                      feature2['horaires_fermeture'],
                      feature2['fermeture_exception'],
                      feature2['horaires_exception'],
                    );

                    final Parking parkingFinal = Parking.fromGeoJson(
                      feature2,
                      parking.nom,
                      parking.npPlacesDisponiblesVoitures,
                      horaires,
                      tarifs,
                    );

                    listeParkingFinale.add(parkingFinal);
                  }
                }
              }
            }

          } else {
            throw Exception('Failed to load addresses');
          }
        }
      }catch (e) {
        throw Exception('An error occurred: $e');
      }
    }
    return listeParkingFinale;
  }

  Future<List<Parking>> fetchAllParking() async {
    final List<Parking> listeParkingFinale = [];
    try {
      final Response response = await get(Uri.parse('https://data.angers.fr/api/explore/v2.1/catalog/datasets/parking-angers/records?limit=20'));
      if (response.statusCode == 200) {
        final Response response2 = await get(Uri.parse('https://data.angers.fr/api/explore/v2.1/catalog/datasets/angers_stationnement/records?limit=20'));
        if (response2.statusCode == 200) {
          final Map<String, dynamic> json = jsonDecode(response.body);
          if (json.containsKey("results")) {
            final List<dynamic> features = json['results'];
            for (Map<String, dynamic> feature in features) {
              final parking = Parking.fromJson(feature);
              final String nomDuParking = parking.nom;
              final Map<String, dynamic> json2 = jsonDecode(response2.body);
              if (json2.containsKey("results")) {
                final List<dynamic> features2 = json2['results'];
                for (Map<String, dynamic> feature2 in features2) {
                  if(nomDuParking == feature2['id_parking']){
                    final Tarifs tarifs = Tarifs(
                      feature2['tarif_1h'],
                      feature2['tarif_2h'],
                      feature2['tarif_3h'],
                      feature2['tarif_4h'],
                      feature2['tarif_24h'],
                    );

                    final Horaires horaires = Horaires(
                      feature2['accessibilite'] == '24-24' ? true : false,
                      feature2['horaires_ouverture'],
                      feature2['horaires_fermeture'],
                      feature2['fermeture_exception'],
                      feature2['horaires_exception'],
                    );

                    final Parking parkingFinal = Parking.fromGeoJson(
                      feature2,
                      parking.nom,
                      parking.npPlacesDisponiblesVoitures,
                      horaires,
                      tarifs,
                    );

                    listeParkingFinale.add(parkingFinal);

                  }
                }
              }
            }
          }

        } else {
          throw Exception('Failed to load addresses');
        }
      }
    }catch (e) {
      throw Exception('An error occurred: $e');
    }
    return listeParkingFinale;
  }



}
