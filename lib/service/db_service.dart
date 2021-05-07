import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sf_notes/auth/auth.dart';
import 'package:sf_notes/model/note.dart';
import 'package:sf_notes/utils/form_validators.dart';

import '../auth/auth.dart';
import '../utils/form_validators.dart';

class FirestoreDbService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map> createUserProfile(
      {String userId,
      String email,
      String displayName,
      String password}) async {
    try {
      await _db.collection('user_profiles').doc(userId).set({
        'userId': userId,
        'email': email,
        'displayName': displayName,
        'p@ssWord': password
      });

      return {'success': 'user created'};
    } catch (error) {
      debugPrint('error in creating profile:  $error');
      return {'error': error};
    }
  }

  Map<String, dynamic> updatePassword(String password) {}

  Stream<List<Note>> getUserNotesStream() {
    return _db
        .collection('user_notes')
        .doc(loggedInUser.userId)
        .collection('notes')
        .orderBy('modifiedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => Note.fromJson(document.data(), document.id))
            .toList());
  }

  Future<bool> addNewNote(
      String title, String description, String imagePath) async {
    try {
      String imageUrl = '';
      if (imagePath.isNotEmpty) {
        firebase_storage.UploadTask _task = await uploadFile(File(imagePath));
        imageUrl = await (await _task).ref.getDownloadURL();
      } else {
        imageUrl = imagePath;
      }
      await _db
          .collection('user_notes')
          .doc(loggedInUser.userId)
          .collection('notes')
          .add({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'modifiedAt': DateTime.now().millisecondsSinceEpoch,
        'createdUserId': loggedInUser.userId,
      });
      showToastMessages('Note Added');
      return true;
    } catch (e) {
      showToastMessages(e);
      return false;
    }
  }

  void deleteNote(String noteId) async {
    try {
      await _db
          .collection('user_notes')
          .doc(loggedInUser.userId)
          .collection('notes')
          .doc(noteId)
          .delete();
      showToastMessages('Note deleted');
    } catch (e) {
      showToastMessages(e);
    }
  }

  Future<bool> updateNote(String noteId, String title, String description,
      String imagePath, bool doesImageUpdated) async {
    try {
      String imageUrl = '';
      if (imagePath.isNotEmpty && doesImageUpdated) {
        firebase_storage.UploadTask _task = await uploadFile(File(imagePath));
        imageUrl = await (await _task).ref.getDownloadURL();
      } else {
        imageUrl = imagePath;
      }
      await _db
          .collection('user_notes')
          .doc(loggedInUser.userId)
          .collection('notes')
          .doc(noteId)
          .update({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'modifiedAt': DateTime.now().millisecondsSinceEpoch,
      });
      showToastMessages('Note updated');
      return true;
    } catch (e) {
      showToastMessages(e.toString());
      return false;
    }
  }

  Future<firebase_storage.UploadTask> uploadFile(File file) async {
    firebase_storage.UploadTask uploadTask;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(loggedInUser.userId)
        .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg', customMetadata: {'file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }
    return Future.value(uploadTask);
  }

  Future<bool> validateOldPassword(String oldPassword) async {
    User user = FirebaseAuth.instance.currentUser;

    EmailAuthCredential credential = EmailAuthProvider.credential(
        email: loggedInUser.email, password: oldPassword);

    try {
      UserCredential uc = await user.reauthenticateWithCredential(credential);
      return uc.user != null ? true : false;
    } catch (exception) {
      return false;
    }
  }

  Future<bool> changePassword(String password) async {
    //Create an instance of the current user.
    User user = FirebaseAuth.instance.currentUser;

    //Pass in the password to updatePassword.
    try {
      await user.updatePassword(password);
      await _db.collection('user_profiles').doc(loggedInUser.userId).update({
        'p@ssWord': Crypt.sha512(password.trim()).toString(),
      });
      showToastMessages('Password Updated');
      return true;
    } catch (error) {
      showToastMessages(error.toString());
      return false;
    }
  }
}
