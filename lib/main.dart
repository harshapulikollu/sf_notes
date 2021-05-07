import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sf_notes/root_page.dart';

import 'auth/auth.dart';

void main() async {
  /// Makes sure dart able to talk with native code to avoid runtime errors
  WidgetsFlutterBinding.ensureInitialized();

  /// Required for latest firebase packages
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sfNotes by Harsha Pulikollu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(auth: new Auth()),
    );
  }
}
