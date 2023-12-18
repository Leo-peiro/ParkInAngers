class Tarifs{
  final num tarif1H;
  final num tarif2H;
  final num tarif3H;
  final num tarif4H;
  final num tarif24H;

  Tarifs(this.tarif1H, this.tarif2H, this.tarif3H, this.tarif4H, this.tarif24H);

  factory Tarifs.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'];

    return Tarifs(
      json['tarif_1h'],
      json['tarif_2h'],
      json['tarif_3h'],
      json['tarif_4h'],
      json['tarif_24h'],
    );
  }
}
