import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:park_in_angers/models/horaires.dart';
import 'package:park_in_angers/models/tarifs.dart';
import 'package:we_slide/we_slide.dart';
import 'package:park_in_angers/composant/affichage_info_parking.dart';
import 'package:park_in_angers/models/parking.dart';
import 'package:park_in_angers/repositories/parking_repository.dart';

class MapCard extends StatefulWidget {
  const MapCard({super.key});

  @override
  _MapCardState createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  final ParkingRepository parkingRepository = ParkingRepository();
  late List<ParkingMarker> parkings = []; //Liste des parkings qui seront sur la carte

  @override
  void initState() {
    super.initState();
    fetchParkingData();
  }

  late ParkingMarker _selectedParking = ParkingMarker(Parking("", 0, 0, 0, 0, Horaires(true, "","","",""),Tarifs(0,0,0,0,0),0, 0,""));

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
      if (kDebugMode) {
        print('Erreur lors de la récupération des données : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double panelMinSize = 70.0;
    final double panelMaxSize = MediaQuery.of(context).size.height / 1.5;

    return Scaffold(
      backgroundColor: Colors.black,
      body: WeSlide(
        panelMinSize: panelMinSize,
        panelMaxSize: panelMaxSize,
        body: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(47.4666700, -0.5500000),
            initialZoom: 10.6,
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', // l'URL permettant d'afficher la carte
              subdomains: const ['a', 'b', 'c'],
              keepBuffer: 20,
              tileProvider: NetworkTileProvider(),
            ),
            //Les markers sur la carte pour indiquer l'emplacement des parkings
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
            //Pour afficher la position actuelle de l'utilisateur
            CurrentLocationLayer(),
          ],
        ),
        panel: _selectedParking.parkingInfo.nom.isNotEmpty //Si pas de parking sélectionné alors pas de panneau
            ? Container(
              color: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    const Icon(Icons.vertical_align_bottom_rounded,color: Colors.white),
                    const Padding(padding: EdgeInsets.only(top: 28)),
                    AffichageInfoParking(parking: _selectedParking.parkingInfo, color: Colors.white),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                  ],
                ),
              ),
            ) : const SizedBox.shrink(),
        panelHeader: _selectedParking.parkingInfo.nom.isNotEmpty //Si pas de parking sélectionné alors pas de panneau
            ? Container(
              height: panelMinSize,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.vertical_align_top_rounded),
                    Text(_selectedParking.parkingInfo.nom),
                  ],
                ),
              ),
            ): const SizedBox.shrink(),
      ),
    );
  }
}

class ParkingMarker {
  final Parking parkingInfo;
  bool isSelected;

  ParkingMarker(this.parkingInfo, {this.isSelected = false});
}
