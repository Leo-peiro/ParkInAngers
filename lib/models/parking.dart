import 'package:park_in_angers/models/tarifs.dart';
import 'package:park_in_angers/models/horaires.dart';


class Parking {
  String nom;
  int npPlacesDisponiblesVoitures;
  int? npPlaceVoituresElectrique;
  int? nbPlacePMR;
  int? nbPlaceVelo;
  Horaires? horaires;
  Tarifs? tarifs;
  num? latitudeY;
  num? longitudeX;
  String? adresse;

  Parking(
      this.nom,
      this.npPlacesDisponiblesVoitures,
      this.npPlaceVoituresElectrique,
      this.nbPlacePMR,
      this.nbPlaceVelo,
      this.horaires,
      this.tarifs,
      this.latitudeY,
      this.longitudeX,
      this.adresse
      );

  Parking.api1Constructeur(
      this.nom,
      this.npPlacesDisponiblesVoitures
      );

  factory Parking.fromGeoJson(Map<String, dynamic> json, String nom, int disponible, Horaires horaires, Tarifs tarifs) {
    final properties = json['properties'];
    final npPlacesDisponiblesVoitures = disponible;
    final npPlaceVoituresElectrique = json['nb_voitures_electriques'];
    final nbPlacePMR = json['nb_pmr'];
    final nbPlaceVelo = json['nb_velo'];
    final latitudeY = json['ylat'];
    final longitudeX = json['xlong'];
    final adresse = json['adresse'];
    return Parking(nom, npPlacesDisponiblesVoitures, npPlaceVoituresElectrique, nbPlacePMR, nbPlaceVelo, horaires, tarifs, latitudeY, longitudeX, adresse); // définir constructeur particulier
  }

  factory Parking.fromJson(Map<String, dynamic> json) { // le fromJson a une forme particulière car il est appelé après la première requête API, nous n'avons donc pas toutes les informations nécessaires
    final properties = json['properties'];
    final String nom = json['nom'];
    final int npPlacesDisponiblesVoitures = json['disponible'];
    // final int npPlaceVoituresElectrique = properties['nb_voitures_electriques'];
    // final int nbPlacePMR = properties['nb_pmr'];
    // final int nbPlaceVelo = properties['nb_velo'];
    // final num latitudeY = properties['ylat'];
    // final num longitudeX = properties['xlong'];

    // final Tarifs tarifs = Tarifs.fromJson(properties);
    // final Horaires horaires = Horaires.fromJson(properties);

    return Parking.api1Constructeur(
      nom,
      npPlacesDisponiblesVoitures
      // npPlaceVoituresElectrique,
      // nbPlacePMR,
      // nbPlaceVelo,
      // horaires,
      // tarifs,
      // latitudeY,
      // longitudeX,
    );
  }
}