import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sandbox/api/api_manager/local_user_credentials.dart';
import 'package:flutter_sandbox/api/api_manager/login_dto.dart';
import 'package:flutter_sandbox/api/api_manager/user_credentials.dart';
import 'package:flutter_sandbox/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//Singleton
class ApiManager {
  static final ApiManager _apiManager = ApiManager._internal();

  factory ApiManager() => _apiManager;

  ApiManager._internal();

  final _loginPath = "/auth/login";

  ValueNotifier<UserCredentials?> _userCredentials = ValueNotifier(null);

  listenCredentials(VoidCallback listenMethod) {
    _userCredentials.addListener(listenMethod);
  }

  get hasCredentials => _userCredentials.value != null;

  Future<http.Response> get(String path) async {
    try {
      Map<String, String> headers = await _getAuthHeader();

      return http.get(_getUri(path), headers: headers);
    } catch (e) {
      throw Exception('Request failed: ${e.toString()}');
    }
  }
  
  Future<http.Response> put(String path, String jsonObject) async {
    try {
      Map<String, String> headers = await _getAuthHeader()..addAll({"Content-Type": "application/json"});

      return http.put(_getUri(path), headers: headers, body: jsonObject);
    } catch (e) {
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  Future<Map<String, String>> _getAuthHeader() async {
    String accessToken = await _getUserAccessToken();
    Map<String, String> headers = {"Authorization": "Bearer $accessToken"};
    return headers;
  }

  Future<void> login(String username, String password) async {
    LoginDto loginDto = LoginDto(grantType: "password", username: username, password: password);

    try {
      var loginJson = jsonEncode(loginDto.toJson());
      var response = await http.post(_getUri(_loginPath), body: loginJson, headers: {"Content-Type": "application/json"});
      if (response.statusCode != 200) {
        logout();
        throw Exception("Could not log user in: ${response.reasonPhrase}");
      }

      await _updateUserCredentials(UserCredentials.fromJson(jsonDecode(response.body)));
    } catch (e) {
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove("credentials");
    _userCredentials.value = null;
  }

  updateCredentialsFromLocal() async {
    var prefs = await SharedPreferences.getInstance();

    String? credentials = prefs.getString("credentials");

    if(credentials != null) {
      var localCredentials = LocalUserCredentials.fromJson(jsonDecode(credentials));
      var validNow = DateTime.now().add(Duration(seconds: 10));
      if(validNow.isBefore(localCredentials.refreshExpiryDateTime))
        _userCredentials.value = UserCredentials.fromLocal(localCredentials);
    }
  }

  _updateUserCredentials(userCredentials) async {
    var prefs = await SharedPreferences.getInstance();

    if(await prefs.setString("credentials", jsonEncode(userCredentials.toJson())))
      _userCredentials.value = userCredentials;
  }

  Future<String> _getUserAccessToken() async {
    var validNow = DateTime.now().add(Duration(seconds: 5));

    var uc = _userCredentials.value;

    if (validNow.isAfter(uc?.expiryDateTime ?? validNow)) {
      if (validNow.isBefore(uc?.refreshExpiryDateTime ?? validNow)) {
        uc = await _refreshUserCredentials(uc!.refreshToken);
      }
    }

    if (uc == null) {
      await logout();
      throw Exception('Invalid user credentials!');
    }

    _updateUserCredentials(uc);
    return uc.accessToken;
  }

  Future<UserCredentials?> _refreshUserCredentials(String refreshToken) async {
    LoginDto loginDto = LoginDto(grantType: "refresh_token", refreshToken: refreshToken);
    http.Response response = await http.post(_getUri(_loginPath),headers: {"Content-Type": "application/json"}, body: jsonEncode(loginDto.toJson()));

    if (response.statusCode == 200) {
      return UserCredentials.fromJson(jsonDecode(response.body));
    }
  }

  Uri _getUri(String path) {
    if (kApiSecure) {
      return Uri.https(kApi, "/adventure$path");
    } else {
      return Uri.http(kApi, "/adventure$path");
    }
  }
}
