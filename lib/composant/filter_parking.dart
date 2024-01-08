import 'package:flutter/material.dart';

class FilterSelectionParking extends StatefulWidget {
  const FilterSelectionParking({super.key});

  @override
  _FilterSelectionParkingState createState() => _FilterSelectionParkingState();
}

class _FilterSelectionParkingState extends State<FilterSelectionParking> {
  bool checkBoxOuvert = false;
  bool checkBoxDispo = false;
  bool checkBoxGratuit = false;
  String selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Veuillez sélectionner des filtres à appliquer'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              items: <String>['Filtre 1', 'Filtre 2', 'Filtre 3']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedFilter = value!;
                });
                print("Filtre sélectionné: $value");
              },
              hint: const Text('Sélectionner un filtre'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text('Ouvert'),
                  value: checkBoxOuvert,
                  onChanged: (bool? value) {
                    setState(() {
                      checkBoxOuvert = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Place disponible'),
                  value: checkBoxDispo,
                  onChanged: (bool? value) {
                    setState(() {
                      checkBoxDispo = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Gratuit'),
                  value: checkBoxGratuit,
                  onChanged: (bool? value) {
                    setState(() {
                      checkBoxGratuit = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                print("Filtre sélectionné: $selectedFilter");
                print("Option 1: $checkBoxOuvert");
                print("Option 2: $checkBoxDispo");
                print("Option 3: $checkBoxGratuit");

                Navigator.pop(context, {
                  'selectedFilter': selectedFilter,
                  'filterOption1': checkBoxOuvert,
                  'filterOption2': checkBoxDispo,
                  'filterOption3': checkBoxGratuit,
                });
              },
              child: const Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }
}
