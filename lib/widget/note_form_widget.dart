import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final String? title;
  final String? contents;
  final String? regUser;

  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedContents;
  final ValueChanged<String> onChangedRegUser;

  const NoteFormWidget({

    Key? key,
    this.title = '',
    this.contents = '',
    this.regUser = '',
    required this.onChangedTitle,
    required this.onChangedContents,
    required this.onChangedRegUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              buildRegUser(),
              buildContents(),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.grey),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildRegUser() => TextFormField(
        maxLines: 1,
        initialValue: regUser,
        style: TextStyle(color: Colors.black, fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'writer',
          hintStyle: TextStyle(color: Colors.grey),
        ),
        validator: (regUser) => regUser != null && regUser.isEmpty
            ? 'The writer cannot be empty'
            : null,
        onChanged: onChangedRegUser,
      );

  Widget buildContents() => TextFormField(
        maxLines: 30,
        initialValue: contents,
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.grey),
        ),
        validator: (contents) => contents != null && contents.isEmpty
            ? 'The contents cannot be empty'
            : null,
        onChanged: onChangedContents,
      );
}
