import 'package:flutter_frontend/services/api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend/services/getLoadIp.dart';

import 'getLoadIp_test.mocks.dart';


const String SERVER_URL = 'https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app/ip.json';

@GenerateMocks([http.Response, http.Client])
void main() {
  test(
      ' GIVEN a http client WHEN loadIp is called THEN returns the Ip',
      () async {
    //GIVEN
    final client = MockClient();
    // Use Mockito to return a successful response when it calls the
    // provided http.Client.
    //WHEN
    when(client.get(Uri.parse(SERVER_URL)))
          .thenAnswer((_) async =>
              http.Response('{"ip": "192.178.292.1"}', 200));
    RetrievedIp ip = await fetchIp(client);

    //THEN
    expect(ip.ip, "192.178.292.1");
  });

  test("GIVEN a http client WHEN 404 is returned THEN throws exception", () {
    //GIVEN
    final client = MockClient();
    String mockResponse = 'Not Found';

    //WHEN
    when(client.get(Uri.parse(SERVER_URL)))
        .thenAnswer((_) async => http.Response(mockResponse, 404));

    //THEN
    expect(fetchIp(client), throwsException);
  });
}