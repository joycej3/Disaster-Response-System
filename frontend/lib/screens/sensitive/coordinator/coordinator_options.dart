import 'dart:math';

import 'package:flutter/material.dart';

// /////////
// // Create a Form widget.
class CoordinatorOptions extends StatefulWidget {
  CoordinatorOptions({Key? key}) : super(key: key);

  @override
  CoordinatorOptionsState createState() => CoordinatorOptionsState();
}

//ambulance 12
//paramedics 120
//fireengines 21
//police 95
//firefighters 963
String ambNum = '';

class CoordinatorOptionsState extends State<CoordinatorOptions> {
  final TextEditingController ambulanceController = TextEditingController();
  final TextEditingController paraController = TextEditingController();
  final TextEditingController fireEng = TextEditingController();
  final TextEditingController policeController = TextEditingController();
  final TextEditingController fightController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    ambulanceController.dispose();
    paraController.dispose();
    fireEng.dispose();
    policeController.dispose();
    fightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          height: 80,
          width: 340,
          child: Text(
            'Please view ML Model suggestions and either accept, or augment them before '
            'confirming a decision',
            style: TextStyle(fontSize: 18, color: Colors.black),
            //softWrap: true,
            textAlign: TextAlign.center,
          )),
      DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Category',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            DataColumn(label: Text('')),
            DataColumn(
              label: Text(
                'Suggestion',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            DataColumn(
              label: Text(
                'Decision',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
          ],

          /// Rows of table
          rows: [
            DataRow(cells: [
              DataCell(Text(
                'Ambulance',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.emergency_sharp, color: Colors.black)),
              DataCell(Text(Random().nextInt(12).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              DataCell(
                TextField(
                  style: TextStyle(color: Colors.blue),
                  controller: ambulanceController,
                  obscureText: false,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
            ]),
            DataRow(cells: [
              DataCell(Text(
                'Paramedics',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.medical_services, color: Colors.black)),
              DataCell(Text(Random().nextInt(120).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              DataCell(
                TextField(
                  style: TextStyle(color: Colors.blue),
                  controller: paraController,
                  obscureText: false,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ]),
            DataRow(cells: [
              DataCell(Text(
                'Fire Engines',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.fire_truck, color: Colors.black)),
              DataCell(Text(Random().nextInt(21).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              DataCell(
                TextField(
                  style: TextStyle(color: Colors.blue),
                  controller: fireEng,
                  obscureText: false,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ]),
            DataRow(cells: [
              DataCell(Text(
                'Police',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.local_police, color: Colors.black)),
              DataCell(Text(Random().nextInt(95).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              DataCell(TextField(
                style: TextStyle(color: Colors.blue),
                controller: policeController,
                obscureText: false,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                'Fire-Fighters',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.fire_hydrant_alt, color: Colors.black)),
              DataCell(Text(Random().nextInt(963).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              DataCell(
                TextField(
                  style: TextStyle(color: Colors.blue),
                  controller: fightController,
                  obscureText: false,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ])
          ]),
      SizedBox(height: 50),
      Container(
        alignment: Alignment.bottomCenter,
        child: TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Confirm/Cancel Decision'),
              content: DataTable(columns: [
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Quantity'))
              ], rows: [
                DataRow(cells: [
                  DataCell(Text('Ambulances: ')),
                  DataCell(Text(ambulanceController.text))
                ]),
                DataRow(cells: [
                  DataCell(Text('Paramedics: ')),
                  DataCell(Text(paraController.text))
                ]),
                DataRow(cells: [
                  DataCell(Text('Fire Engines: ')),
                  DataCell(Text(fireEng.text))
                ]),
                DataRow(cells: [
                  DataCell(Text('Police: ')),
                  DataCell(Text(policeController.text))
                ]),
                DataRow(cells: [
                  DataCell(Text('Fire-Fighters: ')),
                  DataCell(Text(fightController.text))
                ])
              ]),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Change/Cancel'),
                  child: const Text(
                    'Change/Cancel',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Dispatch'),
                  child: const Text(
                    'Dispatch',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          child: const Text('View options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    ])));
  }
}
