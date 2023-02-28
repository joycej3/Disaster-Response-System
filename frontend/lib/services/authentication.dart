import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';
import 'package:flutter_frontend/screens/home.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;
  String uri = 'http://localhost:8080/worker/data';

  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            print("Logged in");
            return WorkerPage();
          } else {
            print("Logged out");
            return Home();
          }
        });
  }

  //SIGN IN METHODJ
  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> extractTokenAndAccessSecureResource() async {
    var token = await extractToken();
    return await accessSecureResource(token);
  }

  Future<String> extractToken() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      String? idToken = await user.getIdToken();
      return idToken;
    }
    return "";
  }

  Future<String> accessSecureResource(token) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer " + token
    };

    Response response = await get(Uri.parse(uri), headers: headers);

    int statusCode = response.statusCode;

    print(statusCode);
    if (statusCode != 200) {
      return "Could not get input from server";
    }
    return response.body.toString();
  }

  //SIGN OUT METHOD
  signOut() {
    print("sign out");
    FirebaseAuth.instance.signOut();
  }
}
