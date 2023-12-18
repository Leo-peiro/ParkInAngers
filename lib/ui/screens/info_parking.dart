import 'package:flutter/material.dart';
import 'package:park_in_angers/models/parking.dart';

class InfoParking extends StatelessWidget {
  const InfoParking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupérez les données du parking depuis les arguments
    final Parking parking = ModalRoute.of(context)!.settings.arguments as Parking;

    return Scaffold(
      appBar: AppBar(
        title: Text('Informations sur le parking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom du parking: ${parking.nom}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Places disponibles: ${parking.npPlacesDisponiblesVoitures}'),
            SizedBox(height: 16),
            Text('Adresse : ${parking.adresse}'),
            SizedBox(height: 16),
            Text('Heure ouverture : ${parking.horaires?.heureOuverture}'),
            SizedBox(height: 16),
            Text('Heure fermeture : ${parking.horaires?.heureFermeture}'),
            SizedBox(height: 16),
            // Ajoutez d'autres informations à afficher ici
          ],
        ),
      ),
    );
  }
}