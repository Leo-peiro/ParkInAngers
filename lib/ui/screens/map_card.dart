import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

import '../../models/adresse.dart';

class MapCard extends StatefulWidget {
  @override
  _MapCardState createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  List<AdresseMarker> adressesAngers = [
    AdresseMarker("Rue de la Roë", LatLng(47.4697, -0.5560)),
    AdresseMarker("Boulevard du Roi René", LatLng(47.4721, -0.5475)),
    AdresseMarker("Avenue Montaigne", LatLng(47.4642, -0.5511)),
  ];

  late AdresseMarker _favoriteParking = AdresseMarker("Rue de la Roë", LatLng(47.4697, -0.5560));

  void setFavoriteParking(AdresseMarker favoriteParking) {
    setState(() {
      _favoriteParking = favoriteParking;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(47.4666700, -0.5500000),
        zoom: 10.6,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          keepBuffer: 20,
          tileProvider: NetworkTileProvider(),
        ),
        MarkerLayer(
          markers: adressesAngers
              .asMap()
              .entries
              .map((entry) => Marker(
            point: entry.value.position,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  for (var other in adressesAngers) {
                    other.isSelected = false;
                  }
                  entry.value.isSelected = !entry.value.isSelected;

                  if (_favoriteParking == entry.value || !_favoriteParking.isSelected) {
                    setFavoriteParking(entry.value);
                  }
                });
              showDialog(
                context: context,
                builder: (context) {
                return AlertDialog(
                  title: Text("Nom de la rue"),
                  content: Text(entry.value.name),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                      Navigator.of(context).pop();
                      },
                      child: Text('Fermer'),
                   ),
                ],
                );
              },
              );
              },
              child: AnimatedContainer(
                alignment : Alignment.center,
                duration: const Duration(milliseconds: 500),
                child: Icon(
                  size: 45.0,
                  Icons.location_pin,
                  color: entry.value.isSelected
                      ? Colors.lightBlueAccent
                      : Colors.red,
                ),
              ),
            ),
          ))
              .toList(),
        ),

        CurrentLocationLayer(),
        Stack(
          children: [
            // Autres widgets de votre page

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Display favorite parking information
                    Text(_favoriteParking.name),
                    Text(_favoriteParking.position.toString()),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class AdresseMarker {
  final String name;
  final LatLng position;
  bool isSelected;

  AdresseMarker(this.name, this.position, {this.isSelected = false});
}
