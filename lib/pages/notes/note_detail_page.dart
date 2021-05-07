import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sf_notes/model/note.dart';
import 'package:sf_notes/service/db_service.dart';
import 'package:sf_notes/utils/form_validators.dart';

class NoteDetailPage extends StatefulWidget {
  final Note note;
  NoteDetailPage({this.note});
  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  TextEditingController _titleController;

  TextEditingController _descriptionController;

  String _imagePath = '';
  bool _doesImagePicked = false;

  FirestoreDbService _db = FirestoreDbService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.note != null) {
      _titleController.text = widget.note.title;
      _descriptionController.text = widget.note.description;
      _imagePath = widget.note.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (widget.note != null)
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  _db.deleteNote(widget.note.noteId);
                  Navigator.pop(context);
                }),
          IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.black,
              ),
              onPressed: () {
                _validateNote();
              }),
          IconButton(
              icon: Icon(
                Icons.photo_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                _showBottomSheet(context);
              }),
        ],
      ),
      body: ListView(
        children: [
          TextField(
            controller: _titleController,
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(hintText: 'Title here...'),
          ),
          if (_imagePath.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: _doesImagePicked
                  ? Image.file(File(_imagePath))
                  : Image.network(_imagePath),
            ),
          TextField(
            controller: _descriptionController,
            maxLines: 1000,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Description goes here...'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    final picker = ImagePicker();
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () async {
                    final pickedFile =
                        await picker.getImage(source: ImageSource.camera);

                    setState(() {
                      if (pickedFile != null) {
                        _imagePath = pickedFile.path;
                        _doesImagePicked = true;
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () async {
                    final pickedFile =
                        await picker.getImage(source: ImageSource.gallery);

                    setState(() {
                      if (pickedFile != null) {
                        _imagePath = pickedFile.path;
                        _doesImagePicked = true;
                      }
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  void _validateNote() async {
    if (_titleController.text.isEmpty) {
      showToastMessages('Please enter title');
    } else {
      if (widget.note == null) {
        showToastMessages('Adding Note');

        ///Add new note
        bool noteAdded = await _db.addNewNote(
            _titleController.text, _descriptionController.text, _imagePath);

        if (noteAdded) {
          Navigator.pop(context);
        }
      } else {
        showToastMessages('Updating Note');

        ///Update the note
        bool noteUpdated = await _db.updateNote(
            widget.note.noteId,
            _titleController.text,
            _descriptionController.text,
            _imagePath,
            _doesImagePicked);
        if (noteUpdated) {
          Navigator.pop(context);
        }
      }
    }
  }
}
