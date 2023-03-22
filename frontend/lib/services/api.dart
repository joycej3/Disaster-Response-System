import 'dart:convert';
import 'package:flutter_frontend/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:flutter_frontend/services/getLoadIp.dart';

const Map<String, dynamic> MAPDEFAULT = {};

class ApiHandler {
  bool configReady = false;

  httpCall(String apiUrl, String apiPath, Map<String, dynamic> arguements,
      String type, http.Client client) async {
    var response;

    if (type == "get") {
      Uri uri = Uri.http(apiUrl, apiPath, arguements);
      response = await client.get(uri);
    } else {
      Uri uri = Uri.http(apiUrl, apiPath);
      var body = jsonEncode(arguements);
      response = await client.post(uri,
          headers: {"Content-Type": "application/json"}, body: body);
    }
    return response;
  }

  callApi(String apiName, http.Client client,
      [Map<String, dynamic> arguements = MAPDEFAULT])
  async {
    RetrievedIp ip = await fetchIp(http.Client());
    replaceIp(ip);
    print(nameToApiInfo["hello_world"]!["primary"]);

    var response = await httpCall(
        nameToApiInfo[apiName]!["primary"],
        nameToApiInfo[apiName]!["path"],
        arguements,
        nameToApiInfo[apiName]!["type"],
        client);
    if (response.statusCode != 200 &&
        nameToApiInfo[apiName]!.containsKey("fallback")) {
      response = await httpCall(
          nameToApiInfo[apiName]!["fallback"],
          nameToApiInfo[apiName]!["path"],
          arguements,
          nameToApiInfo[apiName]!["type"],
          client);
    }
    return response;
  }

  void replaceIp(RetrievedIp ip) {
    String temp = nameToApiInfo["hello_world"]!["primary"];
    temp = temp.replaceAll("localhost", ip.getIp());
    nameToApiInfo["hello_world"]!["primary"] = temp;
    nameToApiInfo["hello_world"]!["fallback"] = temp;
    nameToApiInfo["database_get"]!["primary"] = temp;
    nameToApiInfo["database_push"]!["primary"] = temp;
  }
}
