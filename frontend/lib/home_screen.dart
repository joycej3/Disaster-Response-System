import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tfi_data_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TFIDataModel>? model;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Http Get Request'),
      ),
      body: model == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ExpansionTile(
                    title: Text(model![index].id ?? ""),
                    children: [Text(model![index].tripUpdate?.trip?.routeId ?? "")],
                  ),
                );
              },
              itemCount: model?.length,
            ),
    );
  }

  Future<void> getData() async {
    var urlString = 'https://api.nationaltransport.ie/gtfsr/v1?format=json';
    var uri = Uri.parse(urlString);
    var response = await http.get(
      uri,
      headers: {
        'x-api-key': '78559b34f9a2440db47429b932ada04c',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      var entities = data["StopTimeUpdate"];
      if (entities != null) {
        List<dynamic> body = entities;
        model =
            body.map((dynamic item) => TFIDataModel.fromJson(item)).toList();
        setState(() {});
      }
    }
  }
}
