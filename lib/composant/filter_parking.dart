import 'package:flutter/material.dart';

class FilterSelectionParking extends StatefulWidget {
  final bool checkBoxOuvert;
  final bool checkBoxDispo;
  final bool checkBoxGratuit;

  const FilterSelectionParking({
    Key? key,
    required this.checkBoxOuvert,
    required this.checkBoxDispo,
    required this.checkBoxGratuit,
  }) : super(key: key);

  @override
  FilterSelectionParkingState createState() => FilterSelectionParkingState();
}

class FilterSelectionParkingState extends State<FilterSelectionParking> {
  bool checkBoxOuvert = false;
  bool checkBoxDispo = false;
  bool checkBoxGratuit = false;

  @override
  void initState() {
    super.initState();
    checkBoxOuvert = widget.checkBoxOuvert;
    checkBoxDispo = widget.checkBoxDispo;
    checkBoxGratuit = widget.checkBoxGratuit;
  }

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
                  title: const Text('Gratuit pour 1h'),
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
                print("checkBoxOuvert: $checkBoxOuvert");
                print("checkBoxDispo: $checkBoxDispo");
                print("checkBoxGratuit: $checkBoxGratuit");

                Navigator.pop(context, {
                  'checkBoxOuvert': checkBoxOuvert,
                  'checkBoxDispo': checkBoxDispo,
                  'checkBoxGratuit': checkBoxGratuit,
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
