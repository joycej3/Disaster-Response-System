import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

Future<Map> readJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  var map = jsonDecode(input);
  print("get map");
  print(map);
  return map;
}

<<<<<<< HEAD
class ApiHandler {
  Map nameToApiInfo = Map();
  bool configReady = false;

  call_api(String apiName) async {
    if (!configReady) {
=======

class ApiHandler{
  Map nameToApiInfo = {};
  bool configReady = false;

  callApi(String apiName) async {
    if (!configReady){
>>>>>>> ef4d3ffa21b045ba9f5069fe076777dacd2fa0a4
      nameToApiInfo = await readJsonFile("config/api.json");
      configReady = true;
    }

    var response = await http.get(Uri.parse(nameToApiInfo[apiName]["primary"]));

    if (response.statusCode != 200 &&
        nameToApiInfo[apiName].containsKey("fallback")) {
      response = await http.get(Uri.parse(nameToApiInfo[apiName]["fallback"]));
    }
    return response;
  }
}
