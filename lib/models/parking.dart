import 'package:park_in_angers/models/tarifs.dart';
import 'package:park_in_angers/models/horaires.dart';


class Parking {
  final String name;
  final int npPlacesDisponiblesVoitures;
  final int npPlaceVoituresElectrique;
  final int nbPlacePMR;
  final int nbPlaceVelo;
  final Horaires horaires;
  final Tarifs tarifs;

  const Parking(
      this.name,
      this.npPlacesDisponiblesVoitures,
      this.npPlaceVoituresElectrique,
      this.nbPlacePMR,
      this.nbPlaceVelo,
      this.horaires,
      this.tarifs
      );
}