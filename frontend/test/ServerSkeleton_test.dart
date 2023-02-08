// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_frontend/api.dart';
import 'package:flutter_frontend/api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend/ServerSkeleton.dart';

import 'ServerSkeleton_test.mocks.dart';

const String SERVER_URL = 'http://localhost:8080/firebase_get';


@GenerateMocks([ApiHandler, http.Response, http.Client])
void main() {

  test(' GIVEN a http client WHEN the http call completes successfully THEN returns a DisasterResponse', () async {
    //GIVEN
    final apiHandler = MockApiHandler();
    // Use Mockito to return a successful response when it calls the
    // provided http.Client.
    //WHEN
    when(apiHandler
        .callApi(any))
        .thenAnswer((_) async =>
        http.Response('{"DisasterType": "Hurricane", "DisasterTime": "12:06"}', 200));

    //THEN
    expect(await fetchAlbum(apiHandler), isA<DisasterResponse>());
  });

  test("GIVEN a http client WHEN 404 is returned THEN throws exception", () {
    //GIVEN
     final apiHandler = MockApiHandler();
    String mockResponse = 'Not Found';

    //WHEN
    when(apiHandler
        .callApi(any))
        .thenAnswer((_) async =>
        http.Response(mockResponse, 404));

    expect(fetchAlbum(apiHandler), throwsException);
  });

  test("Empty test", ()
  {
    //GIVEN
    int dummyVar = 0;
    //WHEN
    dummyVar += 3;
    //THEN
    expect(dummyVar, 3);
  });

  testWidgets('button exists and has text', (tester) async {
    //GIVEN
    await tester.pumpWidget(const MyApp());

    //WHEN
    final buttonFinder = find.byType(ElevatedButton);
    final buttonTextFinder = find.text('fetch from server');

    //THEN
    expect(buttonFinder, findsOneWidget);
    expect(buttonTextFinder, findsOneWidget);
  });
}
