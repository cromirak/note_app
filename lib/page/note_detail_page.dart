import 'package:flutter/material.dart';
import 'package:note_app/db/notes_database.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/page/edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  final String? subTitle;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
    this.subTitle,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.subTitle ?? '',
            style: TextStyle(fontSize: 24),
          ),
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.createdTime.split('.')[0],
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.regUser,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.contents,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );
}
