import 'package:park_in_angers/main.dart';
import 'package:park_in_angers/ui/screens/info_parking.dart';
import 'package:park_in_angers/ui/screens/liste_parking.dart';

class AppRouter{
    // static const String homePage = '/home';
    static const String listeParking = '/liste_parking';
    static const String infoParking = '/info_parking';
    static const String navigation = '/navigation';

    static final routes = {
      // homePage: (context) => const Home(),
      navigation: (context) => NavigationMenu(),
      listeParking: (context) => ListeParking(),
      infoParking: (context) => InfoParking(),

    };
}