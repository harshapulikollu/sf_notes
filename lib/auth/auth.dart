import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sf_notes/model/user.dart';
import 'package:sf_notes/service/db_service.dart';

AppUser loggedInUser;

abstract class BaseAuth {
  Future<String> currentUser();
  Future<Map> signIn(String email, String password);
  Future<String> signUpUser(
    String email,
    String password,
  );
  Future<Map<dynamic, dynamic>> createUser(
    String email,
    String hashedPassword,
    String displayName,
  );
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final ref = FirebaseFirestore.instance.collection("user_profiles");
  @override
  Future<String> signUpUser(String email, String password) async {
    final User user = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    return user.uid;
  }

  @override
  Future<String> currentUser() async {
    User user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot userRecord = await ref.doc(user.uid).get();
      loggedInUser = new AppUser.fromDocument(userRecord);
    }
    return user != null ? user.uid : null;
  }

  @override
  Future<Map> signIn(String email, String password) async {
    try {
      User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      DocumentSnapshot userRecord = await ref.doc(user.uid).get();
      loggedInUser = new AppUser.fromDocument(userRecord);
      return {'userId': user.uid};
    } catch (exception) {
      return {'error': exception.toString()};
    }
  }

  @override
  Future<void> signOut() async {
    loggedInUser = null;
    return await _firebaseAuth.signOut();
  }

  @override
  Future<Map<dynamic, dynamic>> createUser(
    String email,
    String hashedPassword,
    String displayName,
  ) async {
    FirestoreDbService _db = FirestoreDbService();

    User user = _firebaseAuth.currentUser;

    Map<dynamic, dynamic> result = await _db.createUserProfile(
        userId: user.uid,
        email: user.email,
        displayName: displayName,
        password: hashedPassword);

    DocumentSnapshot userRecord = await ref.doc(user.uid).get();
    loggedInUser = new AppUser.fromDocument(userRecord);
    return result;
  }
}
