import 'package:flutter/material.dart';
import 'package:park_in_angers/models/parking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:park_in_angers/composant/affichage_info_parking.dart';

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
    parking = ModalRoute.of(context)!.settings.arguments as Parking;
    initialisation();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations sur le parking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AffichageInfoParking(parking: parking),
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

  Future<void> initialisation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    for (String name in favorites){
      if(!isFavorite) {
        if (name == parking.nom) {
          setState(() {
            isFavorite = true;
          });
        }
      }
    }
  }
  Future<void> toggleFavorite() async {
    await toggleFavoriteP(parking);
  }

  Future<void> toggleFavoriteP(Parking parking) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    if (favorites.contains(parking.nom)) {
      favorites.remove(parking.nom);
    } else {
      favorites.add(parking.nom);
    }
    setState(() {
          isFavorite = !isFavorite;
        });
    await prefs.setStringList('favorites', favorites);
  }
}
