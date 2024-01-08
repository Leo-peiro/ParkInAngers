import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:park_in_angers/models/horaires.dart';
import 'package:park_in_angers/models/tarifs.dart';
import 'package:we_slide/we_slide.dart';

import '../../models/parking.dart';
import '../../repositories/parking_repository.dart';

class MapCard extends StatefulWidget {
  @override
  _MapCardState createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  final ParkingRepository parkingRepository = ParkingRepository();
  late List<ParkingMarker> parkings = [];

  @override
  void initState() {
    super.initState();
    fetchParkingData();
  }

  late ParkingMarker _selectedParking = ParkingMarker(Parking("Nom du parking", 10, 0, 0, 0, Horaires(true, "8:00","23:00","Férié","Pas de fermeture"),Tarifs(2,3,4,6,16),47.4697, -0.5560,"Rue de la Roë"));
  //= ParkingMarker("Rue de la Roë", LatLng(47.4697, -0.5560));

  //void setFavoriteParking(ParkingMarker favoriteParking) {
   // setState(() {
   //   _favoriteParking = favoriteParking;
   // });
  //}

  void setSelectedParking(ParkingMarker favoriteParking) {
     setState(() {
       _selectedParking = favoriteParking;
    });
  }


  // Fonction pour récupérer les données et mettre à jour l'état
  Future<void> fetchParkingData() async {
    try {
      final List<Parking> parkingList = await parkingRepository.fetchAllParking();
      setState(() {
        parkings = parkingList.map((parking) => ParkingMarker(parking)).toList();
      });
    } catch (e) {
      // Gérez les erreurs ici
      print('Erreur lors de la récupération des données : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _panelMinSize = 70.0;
    final double _panelMaxSize = MediaQuery.of(context).size.height / 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: WeSlide(
        panelMinSize: _panelMinSize,
        panelMaxSize: _panelMaxSize,
        body: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(47.4666700, -0.5500000),
            initialZoom: 10.6,
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              keepBuffer: 20,
              tileProvider: NetworkTileProvider(),
            ),
            MarkerLayer(
              markers: parkings
                  .asMap()
                  .entries
                  .map((entry) => Marker(
                alignment: Alignment.topCenter,
                point: LatLng(entry.value.parkingInfo.latitudeY!.toDouble(), entry.value.parkingInfo.longitudeX!.toDouble()),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      for (var other in parkings) {
                        other.isSelected = false;
                      }
                      entry.value.isSelected = !entry.value.isSelected;

                      if (_selectedParking == entry.value ||
                          !_selectedParking.isSelected) {
                        setSelectedParking(entry.value);
                      }
                    });
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
          color: Colors.lightBlueAccent.shade100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.vertical_align_bottom_rounded),
                SizedBox(height: 28),
                Text(
                  "Plus d'Information du Parking Sélectionné",
                  style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                SizedBox(height: 18),
                Text(
                  'Nom du parking: ${_selectedParking.parkingInfo.nom}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 16, color: Colors.grey),
                Text('Places disponibles: ${_selectedParking.parkingInfo.npPlacesDisponiblesVoitures}'),
                const Divider(height: 16, color: Colors.grey),
                Text('Adresse : ${_selectedParking.parkingInfo.adresse.toString()}'),
                const Divider(height: 16, color: Colors.grey),

                Visibility(
                  visible: _selectedParking.parkingInfo.horaires?.heureOuverture != null && _selectedParking.parkingInfo.horaires?.heureFermeture != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.event_available_sharp, size: 24),
                          const SizedBox(width: 8),
                          Text('Heure ouverture : ${_selectedParking.parkingInfo.horaires?.heureOuverture}'),
                        ],
                      ),
                      const Divider(height: 16, color: Colors.grey),
                      Row(
                        children: [
                          const Icon(Icons.event_busy_sharp, size: 24),
                          const SizedBox(width: 8),
                          Text('Heure fermeture : ${_selectedParking.parkingInfo.horaires?.heureFermeture}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _selectedParking.parkingInfo.horaires?.heureOuverture == null && _selectedParking.parkingInfo.horaires?.heureFermeture == null,
                  child: const Row(
                    children: [
                      Icon(Icons.event_available_sharp, size: 24),
                      // Icon(Icons.loop_sharp, size: 24),
                      SizedBox(width: 8),
                      Text('Accessible 24/24'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        panelHeader: Container(
          height: _panelMinSize,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.vertical_align_top_rounded),
                Text(_selectedParking.parkingInfo.nom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ParkingMarker {
  final Parking parkingInfo;
  bool isSelected;

  ParkingMarker(this.parkingInfo, {this.isSelected = false});
}
