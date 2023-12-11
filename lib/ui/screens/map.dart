import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/adresse.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<Adresse> adressesAngers = [
      Adresse("Rue de la Roë", LatLng(47.4697, -0.5560)),
      Adresse("Boulevard du Roi René", LatLng(47.4721, -0.5475)),
      Adresse("Avenue Montaigne", LatLng(47.4642, -0.5511)),
    ];

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(47.4666700, -0.5500000),
        initialZoom: 10.6,
      ),
      children: [
        TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            keepBuffer: 20,
            tileProvider: NetworkTileProvider()),
      ],
    );
  }
}