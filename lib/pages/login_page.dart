import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/api/api_manager/api_manager.dart';
import 'package:flutter_sandbox/providers/adventures_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final focusPassword = FocusNode();
    final focusLogin = FocusNode();

    String username = "", password = "";

    var _submitForm = (context) async {
      // Validate returns true if the form is valid, or false otherwise.
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        try {
          await ApiManager().login(username, password);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Login successful"),
            duration: Duration(seconds: 3),
          ));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Login failed ${e.toString()}"),
            duration: Duration(seconds: 30),
          ));
          rethrow;
        }
      }
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Username',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'required';
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusPassword);
                          },
                          onSaved: (value) {
                            username = value ?? "";
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          }
                        },
                        focusNode: focusPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (v) {
                          _submitForm(context);
                        },
                        onSaved: (value) {
                          password = value ?? "";
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        focusNode: focusLogin,
                        onPressed: () => _submitForm(context),
                        child: Text('Login'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
