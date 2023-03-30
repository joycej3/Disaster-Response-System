import 'dart:convert';
import 'dart:io';
import 'package:flutter_frontend/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:flutter_frontend/services/getLoadIp.dart';
import 'package:http/http.dart';

const Map<String, dynamic> MAPDEFAULT = {};
const Map<String, String> HEADERDEFAULT = {"Content-Type": "application/json"};

class ApiHandler {
  bool configReady = false;

  Future<Response> httpCall(String apiUrl, String apiPath, Map<String, dynamic> arguements,
      String type, Client client, Map<String, String> requestHeaders) async {
      var response;

      if (type == "get") {
        Uri uri = Uri.http(apiUrl, apiPath, arguements);
        print(uri);
        response = await client.get(uri, headers: requestHeaders);
      } else {
        Uri uri = Uri.http(apiUrl, apiPath);
        var body = jsonEncode(arguements);
        response = await client.post(uri,
            headers: requestHeaders, body: body);
      }
      return response;
  }

  Future<Response> callApi(String apiName, Client client,
      [Map<String, dynamic> arguements = MAPDEFAULT,
      Map<String, String> requestHeaders = HEADERDEFAULT])
  async {
    RetrievedIp ip = await fetchIp(client);
    replaceIp(ip);
    print(nameToApiInfo["hello_world"]!["primary"]);
    print(requestHeaders);

    var response = await httpCall(
        nameToApiInfo[apiName]!["primary"],
        nameToApiInfo[apiName]!["path"],
        arguements,
        nameToApiInfo[apiName]!["type"],
        client,
        requestHeaders);
    if (response.statusCode != 200 &&
        nameToApiInfo[apiName]!.containsKey("fallback")) {
      response = await httpCall(
          nameToApiInfo[apiName]!["fallback"],
          nameToApiInfo[apiName]!["path"],
          arguements,
          nameToApiInfo[apiName]!["type"],
          client,
          requestHeaders);
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
    nameToApiInfo["get_user_info"]!["primary"] = temp;
  }
}
