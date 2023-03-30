import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/login.dart';
import 'package:flutter_frontend/screens/custom_form.dart';
import 'package:flutter_frontend/screens/map.dart';

class RedButton extends StatefulWidget {
  RedButton({Key? key}) : super(key: key);

  @override
  DrawRedButton createState() => DrawRedButton();
}

class DrawRedButton extends State<RedButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            )),
      ),
    );
  }
}
