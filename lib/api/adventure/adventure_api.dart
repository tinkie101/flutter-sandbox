import 'dart:convert';

import 'package:flutter_sandbox/api/adventure/adventure.dart';
import 'package:flutter_sandbox/api/api_manager/api_manager.dart';
import 'package:http/http.dart' as http;

class AdventureApi {
  final _apiManager = ApiManager();

  Future<List<Adventure>> getAllAdventures() async {
      http.Response response = await _getAdventuresResponse();

      List<Adventure> adventures = (jsonDecode(response.body) as List)
          .map((fm) => Adventure.fromJson(fm))
          .toList();

      return adventures;
  }

  Future<Adventure> updateAdventure(Adventure adventure) async {
    http.Response response = await _updateAdventuresResponse(adventure);

    if (response.statusCode != 200) {
      throw Exception('Failed to load list of adventures: ${response.body}');
    }

    return Adventure.fromJson(jsonDecode(response.body));
  }

  Future<http.Response> _getAdventuresResponse() async {
    http.Response response = await _apiManager.get("/adventures");
    
    if (response.statusCode != 200) {
      throw Exception('Failed to load list of adventures: ${response.body}');
    }
    
    return response;
  }
  
  Future<http.Response> _updateAdventuresResponse(Adventure adventure) async {
    http.Response response = await _apiManager.put("/adventure/${adventure.id}", jsonEncode(adventure.toJson()));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to load list of adventures: ${response.body}');
    }
    
    return response;
  }
}
