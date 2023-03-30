import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_frontend/services/api.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';
import 'package:flutter_frontend/screens/home.dart';

const Map<String, dynamic> MAPDEFAULT = {};

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ApiHandler apiHandler = ApiHandler();

  get user => _auth.currentUser;

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
  Future<Object?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<Response> secureApi(String apiName,
      [Map<String, dynamic> arguements = MAPDEFAULT]) async {
    var token = await extractToken();
    return await accessSecureResource(apiName, arguements, token);
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

  Future<Response> accessSecureResource(String apiName,Map<String, dynamic> arguements, token) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer " + token
    };
    return apiHandler.callApi(apiName, http.Client(), arguements, headers);
  }

  //SIGN OUT METHOD
  signOut() {
    print("sign out");
    FirebaseAuth.instance.signOut();
  }
}
