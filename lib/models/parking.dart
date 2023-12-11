import 'package:park_in_angers/models/tarifs.dart';

class Parking {
  final String name;
  final int npPlacesDisponiblesVoitures;
  final int npPlaceVoituresElectrique;
  final int nbPlacePMR;
  final int nbPlaceVelo;
  final bool estOuvert;
  final String? heureOuverture; // peut etre null dans le cas des parking ouverts 24/24
  final String? heureFermeture;
  final Tarifs tarifs;

  const Parking(
      this.name,
      this.npPlacesDisponiblesVoitures,
      this.npPlaceVoituresElectrique,
      this.nbPlacePMR,
      this.nbPlaceVelo,
      this.estOuvert,
      this.heureOuverture,
      this.heureFermeture,
      this.tarifs
      );
}