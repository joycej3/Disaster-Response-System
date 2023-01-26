import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/main.dart';
import 'package:http/http.dart' as http;

Future<DisasterResponse> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app/test.json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(jsonDecode(response.body));
    return DisasterResponse.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class DisasterResponse {
  final bool disaster;
  final bool sad;

  const DisasterResponse({
    required this.disaster,
    required this.sad,
  });

  factory DisasterResponse.fromJson(Map<String, dynamic> json) {
    return DisasterResponse(
      disaster: json['disaster'],
      sad: json['sad'],
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
      futureAlbum = fetchAlbum();
    });
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
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
                    child: Text("fetch from Firebase")
                )
            ),

            Center(
              child: FutureBuilder<DisasterResponse>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        "disaster: ${snapshot.data!.disaster}\n"
                            "sad: ${snapshot.data!.sad}"
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