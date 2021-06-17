import 'dart:convert';

import 'package:flutter_sandbox/api/adventure.dart';
import 'package:flutter_sandbox/constants.dart';
import 'package:http/http.dart' as http;

class AdventureApi {
  static Future<List<Adventure>> getAllAdventures() async {
    http.Response response = await _getAdventuresResponse();

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load list of adventures: ${response.body}');
    }
  print("returned");
    List<Adventure> adventures =
    (jsonDecode(response.body) as List)
        .map((fm) => Adventure.fromJson(fm))
        .toList();

    return adventures;
  }

  static Future<http.Response> _getAdventuresResponse() async {

    return http.get(Uri.http(kApi, '/adventures'));
  }
}