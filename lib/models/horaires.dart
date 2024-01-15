class Horaires{
  bool estOuvert;
  final String? heureOuverture; // peut etre null dans le cas des parking ouverts 24/24
  final String? heureFermeture;
  final String? heureFermetureException; // peut etre null dans le cas des parking ouverts 24/24
  final String? horairesException;

  Horaires(this.estOuvert,
      this.heureOuverture,
      this.heureFermeture,
      this.heureFermetureException,
      this.horairesException
      );
}