import 'package:flutter/material.dart';
import 'package:flutter_sandbox/api/api_manager/api_manager.dart';
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
          create: (context) => LoginModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdventuresModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginModel>(
      builder: (context, login, child) => MaterialApp(
        title: 'Flutter Sandbox',
        theme: ThemeData.dark(),
        home: Navigator(
          pages: [
            MaterialPage(key: ValueKey("LoginPage"), child: LoginPage()),
            if (login.loggedIn == true)
              MaterialPage(
                key: ValueKey("HomePage"),
                child: MyHomePage(),
              )
          ],
          onPopPage: (route, result) {
            ApiManager().logout();
            return route.didPop(result);
          },
        ),
      ),
    );
  }
}
