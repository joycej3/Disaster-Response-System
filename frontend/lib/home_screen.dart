import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState(){
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Http Get Request'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ExpansionTile(
              title: Text('HTTP'),
              children: [Text('Testing')],
            ),
          );
        },
        itemCount: 1,
      ),
    );
  }

  Future<void> getData() async{
    var urlString = 'https://api.nationaltransport.ie/gtfsr/v1?format=json';
    var uri = Uri.parse(urlString);
    var response = await http.get(
      uri,
      headers: {
        'x-api-key': '8acd9db0fc384b34945d08b5f631ac20',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }
}
