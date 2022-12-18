import 'package:flutter/material.dart';
import 'package:note_app/db/notes_database.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/page/edit_note_page.dart';
import 'package:note_app/page/note_detail_page.dart';

class NotesPage extends StatefulWidget {
  final String title;

  const NotesPage({Key? key, required this.title}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 46, 139, 87),
        content: Text(message),
      ),
    );
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    log.i(notes);

    setState(() => isLoading = false);
  }

  _deleteFormDialog(BuildContext context, nodeId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are you sure to delete?\nIt can not recover!',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black, // foreground
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    var result = await NotesDatabase.instance.delete(nodeId);
                    if (result != null) {
                      Navigator.pop(context);
                      refreshNotes();
                      _showSuccessSnackBar('Successfully deleted.');
                    }
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 24),
        ),
        // To-Do : Search
        // actions: [Icon(Icons.search), SizedBox(width: 12)],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
                ? Text(
                    'No Notes',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  )
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddEditNotePage(subTitle: "Write")),
          );
          refreshNotes();
        },
      ),
    );
  }

  Widget buildNotes() {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          child: ListTile(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      NoteDetailPage(noteId: note.id!, subTitle: "Detail")));
              refreshNotes();
            },
            title: Text(note.title ?? '',
                style: TextStyle(color: Colors.black, fontSize: 22)),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Writer : ${note.regUser}' ?? '',
                    style: TextStyle(color: Colors.black, fontSize: 10),
                    textAlign: TextAlign.end,
                  ),
                  Text(
                    "Created : " + note.createdTime.split('.')[0],
                    style: TextStyle(color: Colors.black, fontSize: 10),
                    textAlign: TextAlign.end,
                  ),
                  Text(
                    "Edited : " + note.createdTime.split('.')[0],
                    style: TextStyle(color: Colors.black, fontSize: 10),
                    textAlign: TextAlign.end,
                  ),
                ]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddEditNotePage(
                                note: note,
                                subTitle: "Edit",
                              )));
                      refreshNotes();
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.teal,
                    )),
                IconButton(
                    onPressed: () {
                      _deleteFormDialog(context, note.id);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
