import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

const Map<String, dynamic> MAPDEFAULT = {};

Future<Map> readJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  var map = jsonDecode(input);
  return map;
}

class ApiHandler {
  Map nameToApiInfo = {};
  bool configReady = false;

  loadConfig() async {
    if (!configReady) {
      nameToApiInfo = await readJsonFile("config/api.json");
      configReady = true;
    }
  }

  httpCall(String apiUrl, String apiPath, Map<String, dynamic> arguements, String type) async {
    var response;

    if(type == "get"){
      Uri uri = Uri.http(apiUrl, apiPath, arguements);
      print("uri gotten");
      response = await http.get(uri);
    }
    else{
      Uri uri = Uri.http(apiUrl, apiPath);
      var body = jsonEncode(arguements);
      response = await http.post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: body
        );
    }
    return response;
  }

  callApi(String apiName, [Map<String, dynamic> arguements = MAPDEFAULT]) async {
    await loadConfig();

    var response = await httpCall(nameToApiInfo[apiName]["primary"], nameToApiInfo[apiName]["path"], arguements, nameToApiInfo[apiName]["type"]);
    if (response.statusCode != 200 &&
        nameToApiInfo[apiName].containsKey("fallback")) {
      response = await httpCall(nameToApiInfo[apiName]["fallback"], nameToApiInfo[apiName]["path"], arguements, nameToApiInfo[apiName]["type"]);
    }
    return response;
  }
}
