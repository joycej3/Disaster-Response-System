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
        body: Container(
          padding: EdgeInsets.symmetric(),
          child: FloatingActionButton.large(
            backgroundColor: Colors.red,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
