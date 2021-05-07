import 'package:flutter/material.dart';
import 'package:sf_notes/auth/auth.dart';
import 'package:sf_notes/pages/login_and_signup/signup_page.dart';
import 'package:sf_notes/utils/form_validators.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();
  String _email, _password;
  bool _passwordVisible = false;
  bool _showLoadingIndicator = false;

  onSignIn() {
    widget.onSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sf Notes',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
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
                                key: Key('login'),
                                child: Text('Login'),
                                onPressed: () async {
                                  _validateAndSave();
                                }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return SignUpPage(
                                      auth: widget.auth,
                                      onSignIn: widget.onSignIn);
                                }),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: RichText(
                                text: TextSpan(
                                    text: 'New User? ',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Sign up',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))
                                    ]),
                              ),
                            ),
                          )
                        ],
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
        Map loginOutput = await widget.auth.signIn(_email, _password);
        if (loginOutput['error'] == null && loginOutput['userId'] != null) {
          onSignIn();
        } else {
          //error occurred
          setState(() {
            _showLoadingIndicator = false;
          });
          showErrorToast(loginOutput['error']);
        }
        setState(() {
          _showLoadingIndicator = false;
        });
      } catch (e) {
        setState(() {
          _showLoadingIndicator = false;
        });
        showErrorToast(e.toString());
      }
    } else {
      setState(() {
        _showLoadingIndicator = false;
      });
    }
  }
}
