import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf_notes/pages/notes/home_page.dart';
import 'package:sf_notes/pages/splash_screen_page.dart';
import 'package:sf_notes/service/db_service.dart';
import 'auth/auth.dart';
import 'pages/login_and_signup/login_page.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  _RootPageState createState() => _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> with WidgetsBindingObserver {
  AuthStatus _authStatus = AuthStatus.notSignedIn;
  bool _showLoading = true;

  FirestoreDbService _db = FirestoreDbService();

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authStatus =
            userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
        _showLoading = false;
      });
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return _showLoading
            ? SplashScreen()
            : LoginPage(
                auth: widget.auth,
                onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
              );
      case AuthStatus.signedIn:
        return MultiProvider(
          providers: [
            StreamProvider(
              create: (BuildContext context) => _db.getUserNotesStream(),
            )
          ],
          child: HomePage(
            auth: widget.auth,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
          ),
        );
    }
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      _authStatus = status;
      _showLoading = false;
    });
  }
}
