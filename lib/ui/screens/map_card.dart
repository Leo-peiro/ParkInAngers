import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:park_in_angers/models/horaires.dart';
import 'package:park_in_angers/models/tarifs.dart';
import 'package:we_slide/we_slide.dart';

import '../../composant/affichage_info_parking.dart';
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

  late ParkingMarker _selectedParking = ParkingMarker(Parking("", 0, 0, 0, 0, Horaires(true, "","","",""),Tarifs(0,0,0,0,0),0, 0,""));

  //void setFavoriteParking(ParkingMarker favoriteParking) {
   // setState(() {
   //   _favoriteParking = favoriteParking;
   // });
  //}

  void setSelectedParking(ParkingMarker selectedParking) {
     setState(() {
       _selectedParking = selectedParking;
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
        panel: _selectedParking.parkingInfo.nom.isNotEmpty
            ? Container(
          color: Colors.lightBlueAccent.shade100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.vertical_align_bottom_rounded),
                SizedBox(height: 28),
                Text(
                  "Plus d'Informations sur le Parking Sélectionné",
                  style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                SizedBox(height: 18),
                AffichageInfoParking(parking: _selectedParking.parkingInfo),
              ],
            ),
          ),
        ) : SizedBox.shrink(),
        panelHeader: _selectedParking.parkingInfo.nom.isNotEmpty
            ? Container(
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
        ): SizedBox.shrink(),
      ),
    );
  }
}

class ParkingMarker {
  final Parking parkingInfo;
  bool isSelected;

  ParkingMarker(this.parkingInfo, {this.isSelected = false});
}
