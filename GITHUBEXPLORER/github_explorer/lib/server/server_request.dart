import 'package:github_explorer/model/repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServerRequest {

  static String baseURL = 'https://api.github.com/users/';

  static Future<Stream<Repository>> getRepositories() async {

    final String requestURL = 'flutter/repos';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(baseURL + requestURL)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((data) => (data as List))
        .map((data) => Repository.fromJSON(data));
  }
}
