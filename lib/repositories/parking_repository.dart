import 'package:flutter/gestures.dart';
import 'package:park_in_angers/models/horaires.dart';
import 'package:park_in_angers/models/parking.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:park_in_angers/models/tarifs.dart';

class ParkingRepository {

  // static const String baseUrl = 'http://data.angers.fr/api/explore/v2.1/catalog/datasets/';

  Future<List<Parking>> fetchAllParking() async {
    final List<Parking> listeParkingFinale = [];
    try {
      final Response response = await get(Uri.parse('https://data.angers.fr/api/explore/v2.1/catalog/datasets/parking-angers/records?limit=20'));
      print(response);
      if (response.statusCode == 200) {
        print("status 200");

        final Map<String, dynamic> json = jsonDecode(response.body);
        print("json : ");
        print(json);
        if (json.containsKey("results")) {
          print("dans le if");
          final List<dynamic> features = json['results'];
          print(features);
          for (Map<String, dynamic> feature in features) {
            print("dans le for map string dynamic");
            print(feature);
            final parking = Parking.fromJson(feature);
            print("fromJson passed");
            // final String nomDuParking = "'${parking.nom}'";
            final String nomDuParking = parking.nom;

            print(nomDuParking);

            final Response response2 = await get(Uri.parse('https://data.angers.fr/api/explore/v2.1/catalog/datasets/angers_stationnement/records?where=id_parking="${nomDuParking}"&limit=20'));
            print('response2 obtenue');
            if (response2.statusCode == 200) {
              print('status 2OO');

              final Map<String, dynamic> json2 = jsonDecode(response2.body);
              print("json2");
              print(json2);
              if (json2.containsKey("results")) {
                final List<dynamic> features2 = json2['results'];
                print("features2");
                print(features2);
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
      return listeParkingFinale;
    }catch (e) {
        throw Exception('An error occurred: $e');
    }
  }






  // provoque une erreur
  // Future<List<Parking>> fetchAllParking() async {
  //   final Response response = await get(Uri.parse(
  //       'https://data.angers.fr/api/explore/v2.1/catalog/datasets/parking-angers/records?limit=20'));
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> listeParking1 = [
  //     ]; // Liste que la méthode va renvoyer
  //     final List<Parking> listeParkingFinale = [
  //     ]; // Liste que la méthode va renvoyer
  //
  //     // Transformation du JSON (String) en Map<String, dynamic>
  //     final Map<String, dynamic> json = jsonDecode(response.body);
  //     if (json.containsKey("features")) {
  //       // Récupération des "features"
  //       final List<dynamic> features = json['features'];
  //       // Transformation de chaque "feature" en objet de type "Address"
  //       for (Map<String, dynamic> feature in features) {
  //         final parking = [
  //           feature['properties']['nom'],
  //           feature['properties']['disponible']
  //         ];
  //         // lignes à remplacer
  //         // final Parking parking = Parking.fromGeoJson1(feature);
  //         listeParking1.add(parking);
  //       }
  //       // for each parkings in listeParking:
  //       for (List<dynamic> parkings in listeParking1) {
  //         String nom = parkings[0]; // Accès au nom
  //         int disponible = parkings[1]; // Accès à la disponibilité
  //         final Response response2 = await get(Uri.parse(
  //             'https://data.angers.fr/api/explore/v2.1/catalog/datasets/angers_stationnement/records?where=id_parking="$nom"limit=20'));
  //         if (response2.statusCode == 200) {
  //           // final List<dynamic> listeParking = []; // Liste que la méthode va renvoyer
  //
  //           // Transformation du JSON (String) en Map<String, dynamic>
  //           final Map<String, dynamic> json2 = jsonDecode(response2.body);
  //           if (json2.containsKey("features")) {
  //             // Récupération des "features"
  //             final List<dynamic> features = json2['features'];
  //             // Transformation de chaque "feature" en objet de type "Address"
  //             for (Map<String, dynamic> feature in features) {
  //
  //               // initialiser un objet horaires et tarifs !
  //               final Tarifs tarifs = Tarifs(
  //                   feature['properties']['tarif_1h'],
  //                   feature['properties']['tarif_2h'],
  //                   feature['properties']['tarif_3h'],
  //                   feature['properties']['tarif_4h'],
  //                   feature['properties']['tarif_24h']
  //               );
  //               final Horaires horaires = Horaires(
  //                   feature['properties']['accessibilite'] == '24-24'
  //                       ? true : false,
  //                   feature['properties']['horaires_ouverture'],
  //                   feature['properties']['horaires_fermeture'],
  //                   feature['properties']['fermeture_exception'],
  //                   feature['properties']['horaires_exception']
  //               );
  //
  //               final Parking parkingFinal = Parking.fromGeoJson(
  //                   feature, nom, disponible, horaires, tarifs);
  //               listeParkingFinale.add(parkingFinal);
  //             }
  //           }
  //         }
  //       }
  //       return listeParkingFinale;
  //     } else {
  //       throw Exception('Failed to load addresses');
  //     }
  //   }
  // }


}
