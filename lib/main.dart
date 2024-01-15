import 'package:flutter/material.dart';
import 'package:park_in_angers/router.dart';
import 'package:park_in_angers/ui/screens/liste_favoris.dart';
import 'package:park_in_angers/ui/screens/liste_parking.dart';
import 'package:park_in_angers/ui/screens/map_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/parking.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      routes: AppRouter.routes,
      initialRoute: AppRouter.navigation,
    );
  }
}

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int currentPageIndex = 0;
  List<Parking> favoriteParkings = [];

  @override
  void initState() {
    super.initState();
    loadParkings();
  }

  Future<void> loadParkings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favoriteParkings = ListeParking.parkings.where((parking) => favorites.contains(parking.nom)).toList();
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.public, color: Colors.lightBlueAccent,),
            icon: Icon(Icons.public),
            label: 'Carte',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.star, color: Colors.amberAccent,),
            icon: Icon(Icons.star),
            label: 'Parking favori',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Liste parkings',
          ),
        ],
      ),


      body: <Widget>[
        const Card(
          shadowColor: Colors.transparent,
          margin: EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: MapCard(),
          ),
        ),
        const ListeFavoris(),

        const ListeParking(),
      ][currentPageIndex],
    );
  }

  void redirect() {
    setState(() {
      currentPageIndex = 2;
    });
  }
}