import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sf_notes/model/note.dart';
import 'package:sf_notes/pages/notes/note_detail_page.dart';
import 'package:sf_notes/service/db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class CollapsedNote extends StatelessWidget {
  final Note note;
  CollapsedNote({this.note});

  FirestoreDbService _db = FirestoreDbService();
  @override
  Widget build(BuildContext context) {
    return Slidable(
        child: ListTile(
          isThreeLine: true,
          title: Text(note.title),
          trailing: Text(
            timeago
                .format(DateTime.fromMillisecondsSinceEpoch(note.modifiedAt),
                    locale: 'en_short')
                .toString(),
            style: Theme.of(context).textTheme.caption,
          ),
          subtitle: Text(
            note.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NoteDetailPage(note: note);
            }));
          },
        ),
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => _db.deleteNote(note.noteId),
          ),
        ]);
  }
}
