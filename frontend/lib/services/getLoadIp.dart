import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/main.dart';
import 'package:http/http.dart' as http;

Future<RetrievedIp> fetchIp(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app/ip.json'));

    if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(jsonDecode(response.body));
        return RetrievedIp.fromJson(jsonDecode(response.body));
    } 
    else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
        }
    }

class RetrievedIp {
  final String ip;

  const RetrievedIp({
    required this.ip
  });

  String getIp(){
    return this.ip;
  }

  factory RetrievedIp.fromJson(Map<String, dynamic> json) {
    return RetrievedIp(
      ip: json['ip'],
    );
  }

  
}
