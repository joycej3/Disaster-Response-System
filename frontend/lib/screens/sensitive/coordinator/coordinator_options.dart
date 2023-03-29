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

class CoordinatorOptionsState extends State<CoordinatorOptions> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Column(children: [
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
                'Suggestions',
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
              DataCell(Icon(Icons.local_hospital, color: Colors.black)),
              DataCell(Text(Random().nextInt(12).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              DataCell(TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                'Paramedics',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.medical_services, color: Colors.black)),
              DataCell(Text(Random().nextInt(120).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              DataCell(TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ))
            ]),
            DataRow(cells: [
              DataCell(Text(
                'Fire Trucks',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.fire_truck, color: Colors.black)),
              DataCell(Text(Random().nextInt(21).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              DataCell(TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ))
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ))
            ]),
            DataRow(cells: [
              DataCell(Text(
                'Fire-Fighters',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.fire_hydrant, color: Colors.black)),
              DataCell(Text(Random().nextInt(963).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              DataCell(TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ))
            ])
          ]),
      SizedBox(height: 50),
      Container(
        alignment: Alignment.bottomCenter,
        child: Icon(Icons.send, color: Colors.blue, size: 50),
      ),
    ]));
  }
}
