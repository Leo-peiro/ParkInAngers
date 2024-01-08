import 'package:flutter/material.dart';

import '../models/parking.dart';


class AffichageInfoParking extends StatelessWidget {
  final Parking parking;

  const AffichageInfoParking({super.key, required this.parking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText('Nom du parking: ${parking.nom}', fontSize: 18, fontWeight: FontWeight.bold),
        _buildDivider(),
        _buildText('Places disponibles: ${parking.npPlacesDisponiblesVoitures}'),
        _buildDivider(),
        _buildText('Adresse : ${parking.adresse}'),
        _buildDivider(),
        Visibility(
          visible: parking.horaires?.heureOuverture != null && parking.horaires?.heureFermeture != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconText(Icons.event_available_sharp, 'Heure ouverture : ${parking.horaires?.heureOuverture}'),
              _buildDivider(),
              _buildIconText(Icons.event_busy_sharp, 'Heure fermeture : ${parking.horaires?.heureFermeture}'),
            ],
          ),
        ),
        Visibility(
          visible: parking.horaires?.heureOuverture == null && parking.horaires?.heureFermeture == null,
          child: _buildIconText(Icons.event_available_sharp, 'Accessible 24/24'),
        ),
      ],
    );
  }

  Widget _buildText(String text, {double? fontSize, FontWeight? fontWeight}) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 16, color: Colors.grey);
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
