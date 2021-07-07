import 'package:flutter/material.dart';
import 'package:flutter_sandbox/api/api_manager/api_manager.dart';
import 'package:flutter_sandbox/api/auth_manager/auth_manager.dart';
import 'package:flutter_sandbox/pages/home_page.dart';
import 'package:flutter_sandbox/pages/login_page.dart';
import 'package:flutter_sandbox/providers/adventures_model.dart';
import 'package:flutter_sandbox/providers/login_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AdventuresModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    AuthManager().hasCredentialsStream().listen((hasCredentials) {
      setState(() {
        _isLoggedIn = hasCredentials;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Sandbox',
        theme: ThemeData.dark(),
        home: Navigator(
          pages: [
            MaterialPage(key: ValueKey("LoginPage"), child: LoginPage()),
            if (_isLoggedIn)
              MaterialPage(
                key: ValueKey("HomePage"),
                child: MyHomePage(),
              )
          ],
          onPopPage: (route, result) {
            ApiManager.logout();
            return route.didPop(result);
          },
        ),
      );
  }
}
