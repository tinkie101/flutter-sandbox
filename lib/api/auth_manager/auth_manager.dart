import 'dart:async';
import 'dart:convert';

import 'package:flutter_sandbox/api/api_manager/login_dto.dart';
import 'package:flutter_sandbox/api/api_manager/user_credentials_dto.dart';
import 'package:flutter_sandbox/api/auth_manager/local_user_credentials.dart';
import 'package:flutter_sandbox/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _loginPath = "/auth/login";
//Singleton
class AuthManager {
  static final AuthManager _authManager = AuthManager._internal();

  factory AuthManager() => _authManager;

  AuthManager._internal() {
    _updateCredentialsFromLocal();
  }

  LocalUserCredentials? _userCredentials;
  final StreamController<bool> _hasCredentialsStreamController = StreamController();

  dispose() {
    _hasCredentialsStreamController.close();
  }

  Stream<bool> hasCredentialsStream() => _hasCredentialsStreamController.stream;

  refreshCredentialExpireDates() {
    _setUserCredentials(_userCredentials?.cloneUpdatedExpiryDates());
  }

  updateUserCredentials(UserCredentialsDto userCredentialsDto) {
    LocalUserCredentials localUserCredentials = LocalUserCredentials.fromCredentialsDto(userCredentialsDto);

    return _setUserCredentials(localUserCredentials);
  }

  Future<String> getUserAccessToken() async {
    var validNow = DateTime.now().add(Duration(seconds: 5));

    var uc = _userCredentials;

    if (validNow.isAfter(uc?.expiryDateTime ?? validNow)) {
      if (validNow.isBefore(uc?.refreshExpiryDateTime ?? validNow)) {
        uc = await _refreshUserCredentials(uc!.refreshToken);
      }
    }

    if (uc == null) {
      throw Exception('Invalid user credentials!');
    }

    _setUserCredentials(uc);
    return uc.accessToken;
  }

  clearUserAccessToken() {
    return _setUserCredentials(null);
  }

  _updateCredentialsFromLocal() async {
    var prefs = await SharedPreferences.getInstance();

    String? credentials = prefs.getString("credentials");

    if (credentials != null) {
      var localUserCredentials = LocalUserCredentials.fromJson(jsonDecode(credentials));
      var validNow = DateTime.now().add(Duration(seconds: 10));
      if (validNow.isBefore(localUserCredentials.refreshExpiryDateTime))
        _setUserCredentials(localUserCredentials);
      else
        _setUserCredentials(null);
    } else
      _setUserCredentials(null);
  }

  Future<LocalUserCredentials?> _refreshUserCredentials(String refreshToken) async {
    LoginDto loginDto = LoginDto(grantType: "refresh_token", refreshToken: refreshToken);
    http.Response response = await http.post(_getUri(_loginPath),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(loginDto.toJson()));

    if (response.statusCode == 200) {
      var uc = UserCredentialsDto.fromJson(jsonDecode(response.body));
      return LocalUserCredentials.fromCredentialsDto(uc);
    }
  }

  Uri _getUri(String path) {
    if (kApiSecure) {
      return Uri.https(kApi, "/adventure$path");
    } else {
      return Uri.http(kApi, "/adventure$path");
    }
  }

  _setUserCredentials(LocalUserCredentials? localUserCredentials) async {
    var prefs = await SharedPreferences.getInstance();

    if (localUserCredentials == null)
      prefs.remove("credentials");
    else
      await prefs.setString("credentials", jsonEncode(localUserCredentials.toJson()));

    _userCredentials = localUserCredentials;
    _hasCredentialsStreamController.add(_userCredentials != null);
  }
}
