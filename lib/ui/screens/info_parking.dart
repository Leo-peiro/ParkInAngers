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
        title: const Text('Informations sur le parking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom du parking: ${parking.nom}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 16, color: Colors.grey),
            Text('Places disponibles: ${parking.npPlacesDisponiblesVoitures}'),
            const Divider(height: 16, color: Colors.grey),
            Text('Adresse : ${parking.adresse}'),
            const Divider(height: 16, color: Colors.grey),

            Visibility(
              visible: parking.horaires?.heureOuverture != null && parking.horaires?.heureFermeture != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_available_sharp, size: 24),
                      const SizedBox(width: 8),
                      Text('Heure ouverture : ${parking.horaires?.heureOuverture}'),
                    ],
                  ),
                  const Divider(height: 16, color: Colors.grey),
                  Row(
                    children: [
                      const Icon(Icons.event_busy_sharp, size: 24),
                      const SizedBox(width: 8),
                      Text('Heure fermeture : ${parking.horaires?.heureFermeture}'),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: parking.horaires?.heureOuverture == null && parking.horaires?.heureFermeture == null,
              child: const Row(
                children: [
                  Icon(Icons.event_available_sharp, size: 24),
                  // Icon(Icons.loop_sharp, size: 24),
                  SizedBox(width: 8),
                  Text('Accessible 24/24'),
                ],
              ),
            ),
            // Ajoutez d'autres informations à afficher ici
          ],
        ),
      ),
    );
  }
}
