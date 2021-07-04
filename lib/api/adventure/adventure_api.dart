import 'dart:convert';

import 'package:flutter_sandbox/api/adventure/adventure.dart';
import 'package:flutter_sandbox/api/api_manager/api_manager.dart';
import 'package:http/http.dart' as http;

class AdventureApi {
  final _apiManager = ApiManager();

  Future<List<Adventure>> getAllAdventures() async {
      http.Response response = await _getAdventuresResponse();

      if (response.statusCode != 200) {
        throw Exception('Failed to load list of adventures: ${response.body}');
      }

      List<Adventure> adventures = (jsonDecode(response.body) as List)
          .map((fm) => Adventure.fromJson(fm))
          .toList();

      return adventures;
  }

  Future<http.Response> _getAdventuresResponse() async {
    return _apiManager.request("/adventures");
  }
}
