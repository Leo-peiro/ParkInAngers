import 'package:park_in_angers/main.dart';
import 'package:park_in_angers/ui/screens/info_parking.dart';
import 'package:park_in_angers/ui/screens/liste_favoris.dart';
import 'package:park_in_angers/ui/screens/liste_parking.dart';

class AppRouter{
    static const String listeParking = '/liste_parking';
    static const String listeParkingsFavoris = '/liste_favoris';
    static const String infoParking = '/info_parking';
    static const String navigation = '/navigation';

    static final routes = {
      navigation: (context) => const NavigationMenu(),
      listeParking: (context) => const ListeParking(),
      listeParkingsFavoris: (context) => const ListeFavoris(),
      infoParking: (context) => const InfoParking(),

    };
}