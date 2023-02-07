import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/main.dart';
import 'package:http/http.dart' as http;

import "api.dart";

Future<DisasterResponse> fetchAlbum(ApiHandler apiHandler) async {
  final response = await apiHandler.callApi("database_get");

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(getPrettyJSONString(response.body));
    return DisasterResponse.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

String getPrettyJSONString(jsonObject){
  var encoder = new JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}

class DisasterResponse {
  final String response;

  const DisasterResponse({
    required this.response
  });

  factory DisasterResponse.fromJson(Map<String, dynamic> json) {
    return DisasterResponse(
        response: getPrettyJSONString(json)
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<DisasterResponse> futureAlbum;

  void fetch() {

    setState(() {
      futureAlbum = fetchAlbum(ApiHandler());
    });
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(ApiHandler());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Row(
          children: [
            Center(
                child: ElevatedButton(
                    onPressed: fetch,
                    child: Text("fetch from server")
                )
            ),

            Center(
              child: FutureBuilder<DisasterResponse>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        snapshot.data!.response
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),

            ),
          ],
        ),

      ),
    );
  }
}