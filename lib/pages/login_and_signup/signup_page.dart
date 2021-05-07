import 'dart:io';

import 'package:flutter/material.dart';

import '../../auth/auth.dart';
import '../../utils/form_validators.dart';
import 'package:crypt/crypt.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onSignIn;
  final BaseAuth auth;
  SignUpPage({Key key, this.auth, this.onSignIn}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static final formKey = new GlobalKey<FormState>();

  String _email, _password, _displayName;

  bool _passwordVisible = false;

  bool _showLoadingIndicator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              child: FlutterLogo(),
              height: 96,
              width: 96,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            labelText: 'Display Name',
                            filled: true,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          validator: (val) => val.trim().length > 0
                              ? null
                              : 'Please provide name',
                          onSaved: (val) => _displayName = val.trim(),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            labelText: 'email',
                            filled: true,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          validator: (val) => validateEmail(val.trim()),
                          onSaved: (val) => _email = val.trim().toLowerCase(),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            suffixIcon: GestureDetector(
                              child: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                              onTap: () {
                                // Update the state i.e. toggle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            labelText: 'Password',
                            filled: true,
                            contentPadding: EdgeInsets.all(16),
                            //fillColor: Colors.grey,
                          ),
                          validator: (val) => validatePassword(val.trim()),
                          onSaved: (val) => _password = val.trim(),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _validateAndSave(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _showLoadingIndicator
                            ? const CircularProgressIndicator()
                            : OutlinedButton(
                                key: Key('signup'),
                                child: Text('Sign up'),
                                onPressed: () async {
                                  _validateAndSave();
                                }),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  _validateAndSave() async {
    setState(() {
      _showLoadingIndicator = true;
    });
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      try {
        final connection = await InternetAddress.lookup('google.com');
        if (connection.isNotEmpty && connection[0].rawAddress.isNotEmpty) {
          ///calling method to sign up user and creating profile.
          _createNewUser();
        }
      } on SocketException catch (_) {
        setState(() {
          _showLoadingIndicator = false;
        });
        showToastMessages('Oops... No internet');
      }
    } else {
      setState(() {
        _showLoadingIndicator = false;
      });
    }
  }

  void _createNewUser() async {
    String userId =
        await widget.auth.signUpUser(_email.trim(), _password.trim());
    if (userId != null) {
      await widget.auth.createUser(
        _email.trim(),
        Crypt.sha512(_password.trim()).toString(),
        _displayName,
      );
      widget.onSignIn();
      Navigator.pop(context);
    }
  }
}
