import 'dart:convert';

import 'package:flutter_sandbox/api/adventure/adventure.dart';
import 'package:flutter_sandbox/api/api_manager/api_manager.dart';
import 'package:http/http.dart' as http;

class AdventureApi {
  static Future<List<Adventure>> getAllAdventures() async {
      http.Response response = await _getAdventuresResponse();

      List<Adventure> adventures = (jsonDecode(response.body) as List)
          .map((fm) => Adventure.fromJson(fm))
          .toList();

      return adventures;
  }

  static Future<Adventure> createAdventure(Adventure adventure) async {
    http.Response response = await _createAdventureResponse(adventure);

    return Adventure.fromJson(jsonDecode(response.body));
  }

  static Future<Adventure> updateAdventure(Adventure adventure) async {
    http.Response response = await _updateAdventureResponse(adventure);

    return Adventure.fromJson(jsonDecode(response.body));
  }

  static Future deleteAdventure(Adventure adventure) async {
    await _deleteAdventureResponse(adventure);
  }

  static Future<http.Response> _getAdventuresResponse() async {
    http.Response response = await ApiManager.get("/adventures");
    
    if (response.statusCode != 200) {
      throw Exception('Failed to load list of adventures: ${response.body}');
    }
    
    return response;
  }

  static Future<http.Response> _createAdventureResponse(Adventure adventure) async {
    http.Response response = await ApiManager.post("/adventure", jsonEncode(adventure.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to create adventure: ${response.body}');
    }

    return response;
  }

  static Future<http.Response> _updateAdventureResponse(Adventure adventure) async {
    http.Response response = await ApiManager.put("/adventure/${adventure.id}", jsonEncode(adventure.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to update adventure: ${response.body}');
    }

    return response;
  }

  static Future<http.Response> _deleteAdventureResponse(Adventure adventure) async {
    http.Response response = await ApiManager.delete("/adventure/${adventure.id}");

    if (response.statusCode != 200) {
      throw Exception('Failed to delete adventure: ${response.body}');
    }

    return response;
  }
}
