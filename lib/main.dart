import 'package:flutter/material.dart';
import 'package:park_in_angers/router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:park_in_angers/ui/screens/liste_parking.dart';
import 'package:park_in_angers/ui/screens/map_card.dart';

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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: MapCard(),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('Afficher les parking ici, sinon afficher un bouton avec un + qui redirige vers la liste de parking'),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              ElevatedButton(onPressed: redirect, child: const Icon(Icons.add_location_alt_outlined, size: 35)),

            ],
          ),
        ),
        const ListeParking(),
      ][currentPageIndex],
    );
  }

  void redirect() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListeParking()),
    );
  }
}