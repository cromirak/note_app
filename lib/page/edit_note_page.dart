import 'package:flutter/material.dart';
import 'package:note_app/db/notes_database.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/widget/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  final String? subTitle;

  const AddEditNotePage({Key? key, this.note, this.subTitle}) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String contents;
  late String regUser;

  @override
  void initState() {
    super.initState();
    title = widget.note?.title ?? '';
    contents = widget.note?.contents ?? '';
    regUser = widget.note?.regUser ?? '';
  }


  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.subTitle ?? '', style: TextStyle(fontSize: 24)),
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            title: title,
            contents: contents,
            regUser: regUser,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedContents: (contents) =>
                setState(() => this.contents = contents),
            onChangedRegUser: (regUser) =>
                setState(() => this.regUser = regUser),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid =
        title.isNotEmpty && contents.isNotEmpty && regUser.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: isFormValid ? Colors.orangeAccent : Colors.yellow,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      title: title,
      contents: contents,
      regUser: regUser,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      contents: contents,
      regUser: regUser,
      createdTime: DateTime.now().toString(),
      editedTime: DateTime.now().toString(),
    );

    await NotesDatabase.instance.create(note);
  }
}
