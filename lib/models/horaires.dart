class Horaires{
  bool estOuvert;
  final String? heureOuverture; // peut etre null dans le cas des parking ouverts 24/24
  final String? heureFermeture;
  final String? heureFermetureException; // peut etre null dans le cas des parking ouverts 24/24
  final String? horairesException;

  Horaires(this.estOuvert, this.heureOuverture, this.heureFermeture, this.heureFermetureException, this.horairesException);

  factory Horaires.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'];

    return Horaires(
      json['accessibilite'] == '24-24',
      json['horaires_ouverture'],
      json['horaires_fermeture'],
      json['fermeture_exception'],
      json['horaires_exception'],
    );
  }
}