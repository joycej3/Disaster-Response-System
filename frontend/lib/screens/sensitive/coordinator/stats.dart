import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/suggestions.dart';
import 'dart:math';

class Stats extends StatefulWidget {
  @override
  State<Stats> createState() => StatsPage();
}

class StatsPage extends State<Stats> {
  String randNum = Random().nextInt(99).toString();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Scaffold(
                body: Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          height: 80,
          width: 340,
          child: Text(
            'Please view real-time disaster information, or view the disaster on the map. ',
            style: TextStyle(fontSize: 18, color: Colors.black),
            //softWrap: true,
            textAlign: TextAlign.center,
          )),
      DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Info',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            DataColumn(label: Text('')),
            DataColumn(
              label: Text(
                '',
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
                'Location',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.location_city)),
              DataCell(Text('Fingal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            ]),
            DataRow(cells: [
              DataCell(Text(
                'Approximate Area',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.map)),
              DataCell(Text(randNum,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            ]),
            DataRow(cells: [
              DataCell(Text(
                'No.of Reports',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.numbers)),
              DataCell(Text(randNum,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            ]),
            DataRow(cells: [
              DataCell(Text(
                'Disaster Category',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )),
              DataCell(Icon(Icons.category)),
              DataCell(Text('Aliens',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            ]),
          ]),
      SizedBox(height: 50),
      Container(
        alignment: Alignment.bottomCenter,
        child: TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Confirm/Cancel Decision'),
              content: Text('Hello'),
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
          child: const Text('Refresh',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    ]))));
  }
}
