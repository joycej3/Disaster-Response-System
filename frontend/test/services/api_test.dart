import 'package:flutter_frontend/services/api.dart';
import 'package:flutter_frontend/services/getLoadIp.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend/services/api.dart';
import 'package:flutter_frontend/config/api_config.dart';

import 'api_test.mocks.dart';


@GenerateMocks([http.Response, http.Client])
void main() {
  test(
      ' GIVEN an ApiHandler and ip WHEN replaceIp is called THEN the correct Ip is replaced ',
      () async {
    //GIVEN
    ApiHandler handler = ApiHandler();
    String ip = "192.172.192.1";
    RetrievedIp retIp = RetrievedIp(ip: ip);

    //WHEN
    handler.replaceIp(retIp);

    //THEN
    expect(nameToApiInfo["hello_world"]!["primary"], "$ip:8080");
    expect(nameToApiInfo["database_get"]!["primary"], "$ip:8080");
    expect(nameToApiInfo["database_push"]!["primary"], "$ip:8080");
  });

  test(
      ' GIVEN an ApiHandler and client WHEN callApi is called with database_get THEN response is returned.',
    () async {
      //GIVEN
      ApiHandler handler = ApiHandler();
      MockClient client = MockClient();
      http.Response retResponse = http.Response('{"ip": "lorum"}', 200);

      //WHEN
      when(client.get(any)).thenAnswer((_) async =>
      retResponse);
      when(client.get(any, headers: anyNamed("headers"))).thenAnswer((_) async =>
      retResponse);

      //THEN
      expect(await handler.callApi("database_get", client), retResponse);
    });



  test(
      ' GIVEN an ApiHandler and client WHEN callApi is called with database_push THEN response is returned.',
          () async {
        //GIVEN
        ApiHandler handler = ApiHandler();
        MockClient client = MockClient();
        http.Response retResponse =  http.Response('{"ip": "lorum"}', 200);
        var params = {'emergency': "fire",
            'injury': "I am injured",
            'time': 12,
            'location': ""};

        //WHEN
        when(client.get(any)).thenAnswer((_) async =>
        retResponse);
        when(client.post(any, headers: anyNamed("headers"), body: anyNamed("body"))).thenAnswer((_) async =>
        retResponse);

        //THEN
        expect(await handler.callApi("database_push", client, params), retResponse);
      });

  test(
      ' GIVEN an ApiHandler and client WHEN callApi is called with hello_world THEN 404'
          ' response is returned',
          () async {
        //GIVEN
        ApiHandler handler = ApiHandler();
        MockClient client = MockClient();
        http.Response retResponse =  http.Response('{"test": "lorum"}', 404);

        //WHEN
        when(client.get(any)).thenAnswer((_) async =>
        retResponse);

        //THEN
        expect(() => handler.callApi("hello_world", client), throwsA(isA<Exception>()));
      });
}