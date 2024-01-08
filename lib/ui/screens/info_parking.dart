import 'package:flutter/material.dart';
import 'package:park_in_angers/models/parking.dart';

import '../../composant/affichage_info_parking.dart';

class InfoParking extends StatelessWidget {
  const InfoParking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupérez les données du parking depuis les arguments
    final Parking parking = ModalRoute.of(context)!.settings.arguments as Parking;

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

            // ajouter une partie logique : si le parking fait parti des favoris => afficher bouton pour le supprimer des favoris; et l'inverse
            const Divider(height: 16, color: Colors.grey),
            ElevatedButton(onPressed: add, child: const Icon(Icons.add_location_alt_outlined, size: 35)),
            const Divider(height: 16, color: Colors.grey),
            ElevatedButton(onPressed: delete, child: const Icon(Icons.highlight_remove_sharp, size: 35)),
          ],
        ),
      ),
    );
  }

  void add() {
    // ajouter le parking en fav
    print('added');
  }
  void delete() {
    // supprimer le parking des fav
    print('deleted');
  }
}
