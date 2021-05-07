import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf_notes/auth/auth.dart';
import 'package:sf_notes/model/note.dart';
import 'package:sf_notes/pages/notes/note_detail_page.dart';
import 'package:sf_notes/pages/profile/profile_details.dart';
import 'package:sf_notes/widgets/notes/notes_loading_view.dart';
import 'package:sf_notes/widgets/notes/notes_view.dart';
import 'package:sf_notes/widgets/notes/zero_notes_view.dart';

import '../../auth/auth.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      debugPrint('error in sign out $e');
    }
  }

  _HomePageState createState() => _HomePageState(onSignOut: () => _signOut());
}

class _HomePageState extends State<HomePage> {
  VoidCallback onSignOut;
  _HomePageState({this.onSignOut});

  signOutUser() {
    onSignOut();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<List<Note>>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.account_circle_sharp, color: Colors.black),
          onPressed: () {
            _showProfileBS(context);
          },
        ),
        title: Text(
          'Sf Notes',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              onPressed: () {
                onSignOut();
              })
        ],
      ),
      body: notes == null
          ? NotesLoadingView()
          : notes.toList().length == 0
              ? ZeroNotesScreen()
              : NotesView(notes: notes.toList()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add Note',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NoteDetailPage();
          }));
        },
      ),
    );
  }

  void _showProfileBS(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
        builder: (BuildContext context) {
          return ProfileDetails();
        });
  }
}
