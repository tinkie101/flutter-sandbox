import 'package:flutter/cupertino.dart';
import 'package:flutter_sandbox/api/api_manager/api_manager.dart';

class LoginModel extends ChangeNotifier {
  var _isLoggedIn = false;
  var _apiManager = ApiManager();

  LoginModel() {
    _apiManager.listenCredentials(() {
      _isLoggedIn = _apiManager.hasCredentials;
      notifyListeners();
    });

    _apiManager.updateCredentialsFromLocal();
  }

  get loggedIn => _isLoggedIn;
}