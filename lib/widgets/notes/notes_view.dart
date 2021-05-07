import 'package:flutter/material.dart';
import 'package:sf_notes/model/note.dart';
import 'package:sf_notes/widgets/notes/collapsed_note.dart';

class NotesView extends StatelessWidget {
  final List<Note> notes;
  NotesView({this.notes});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return CollapsedNote(note: notes[index]);
        });
  }
}
