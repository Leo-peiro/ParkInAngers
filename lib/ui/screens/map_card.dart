import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:we_slide/we_slide.dart';

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

  late AdresseMarker _favoriteParking =
  AdresseMarker("Rue de la Roë", LatLng(47.4697, -0.5560));

  void setFavoriteParking(AdresseMarker favoriteParking) {
    setState(() {
      _favoriteParking = favoriteParking;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _colorScheme = Theme.of(context).colorScheme;
    final double _panelMinSize = 70.0;
    final double _panelMaxSize = MediaQuery.of(context).size.height / 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: WeSlide(
        panelMinSize: _panelMinSize,
        panelMaxSize: _panelMaxSize,
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(47.4666700, -0.5500000),
            zoom: 10.6,
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png',
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

                      if (_favoriteParking == entry.value ||
                          !_favoriteParking.isSelected) {
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
                    alignment: Alignment.center,
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
          ],
        ),
        panel: Container(
          color: Colors.lightBlueAccent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Information de votre Parking Favoris"),
                Text(_favoriteParking.name),
                Text(_favoriteParking.position.toString()),
              ],
            ),
          ),
        ),
        panelHeader: Container(
          height: _panelMinSize,
          color: Colors.white,
          child: Center(child: Text("Faire glisser vers le haut pour des informations!️")),
        ),
      ),
    );
  }
}

class AdresseMarker {
  final String name;
  final LatLng position;
  bool isSelected;

  AdresseMarker(this.name, this.position, {this.isSelected = false});
}
