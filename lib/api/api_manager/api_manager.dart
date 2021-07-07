import 'dart:convert';
import 'dart:io';

import 'package:flutter_sandbox/api/api_manager/login_dto.dart';
import 'package:flutter_sandbox/api/api_manager/user_credentials_dto.dart';
import 'package:flutter_sandbox/api/auth_manager/auth_manager.dart';
import 'package:flutter_sandbox/constants.dart';
import 'package:http/http.dart' as http;

const _loginPath = "/auth/login";

class ApiManager {
  static final _authManager = AuthManager();

  static Future<http.Response> get(String path) async {
    try {
      Map<String, String> headers = await _getAuthHeader();

      http.Response response = await http.get(_getUri(path), headers: headers);
      if (response.statusCode != 401) {
        _authManager.refreshCredentialExpireDates();
      }
      return response;
    } catch (e) {
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  static Future<http.Response> put(String path, String jsonObject) async {
    try {
      Map<String, String> headers = await _getAuthHeader()..addAll({"Content-Type": "application/json"});

      http.Response response = await http.put(_getUri(path), headers: headers, body: jsonObject);
      if (response.statusCode != 401) {
        _authManager.refreshCredentialExpireDates();
      }
      return response;
    } catch (e) {
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  static Future<http.Response> post(String path, String jsonObject) async {
    try {
      Map<String, String> headers = await _getAuthHeader()..addAll({"Content-Type": "application/json"});

      http.Response response = await http.post(_getUri(path), headers: headers, body: jsonObject);
      if (response.statusCode != 401) {
        _authManager.refreshCredentialExpireDates();
      }
      return response;
    } catch (e) {
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  static Future<http.Response> delete(String path, {String? jsonObject}) async {
    try {
      Map<String, String> headers = await _getAuthHeader();

      http.Response response = await http.delete(_getUri(path), headers: headers, body: jsonObject);
      if (response.statusCode != 401) {
        _authManager.refreshCredentialExpireDates();
      }
      return response;
    } catch (e) {
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  static Future<void> login(String username, String password) async {
    LoginDto loginDto = LoginDto(grantType: "password", username: username, password: password);

    try {
      var loginJson = jsonEncode(loginDto.toJson());
      var response = await http.post(_getUri(_loginPath), body: loginJson, headers: {"Content-Type": "application/json"});
      if (response.statusCode != 200) {
        logout();
        throw Exception("Could not log user in: ${response.reasonPhrase}");
      }

      await _authManager.updateUserCredentials(UserCredentialsDto.fromJson(jsonDecode(response.body)));
    } catch (e) {
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  static logout() async {
    await _authManager.clearUserAccessToken();
  }

  static Future<Map<String, String>> _getAuthHeader() async {
    String accessToken = await _authManager.getUserAccessToken();
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $accessToken"};
    return headers;
  }

  static Uri _getUri(String path) {
    if (kApiSecure) {
      return Uri.https(kApi, "/adventure$path");
    } else {
      return Uri.http(kApi, "/adventure$path");
    }
  }
}
