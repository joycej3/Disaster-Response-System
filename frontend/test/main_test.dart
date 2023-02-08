

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

void  main(){
  test("Dummy test", () {
    //GIVEN
    int lifeExpectancy = 80;
    int advancedSoftware = 30;

    //WHEN
    lifeExpectancy -= advancedSoftware;

    //THEN
    expect(lifeExpectancy, 50);
  });
}