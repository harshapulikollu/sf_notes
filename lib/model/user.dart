import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    this.userId,
    this.email,
    this.displayName,
  });
  final String userId;
  final String email;
  final String displayName;

  factory AppUser.fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data();
    return new AppUser(
      userId: data['userId'],
      email: data['email'],
      displayName: data['displayName'] ?? '',
    );
  }
}
