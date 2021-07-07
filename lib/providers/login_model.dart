import 'package:flutter/cupertino.dart';
import 'package:flutter_sandbox/api/auth_manager/auth_manager.dart';

class LoginModel extends ChangeNotifier {
  var _isLoggedIn = false;

  LoginModel() {
    AuthManager().hasCredentialsStream().listen((hasCredentials) {
      _isLoggedIn = hasCredentials;
      notifyListeners();
    });
  }

  get loggedIn => _isLoggedIn;
}