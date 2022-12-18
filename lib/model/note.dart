final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [

    /// Add all fields
    id, title, contents, regUser, createdTime, editedTime
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String contents = 'contents';
  static final String regUser = 'regUser';
  static final String createdTime = 'createdTime';
  static final String editedTime = 'editedTime';
}

class Note {
  final int? id;
  final String title;
  final String contents;
  final String regUser;
  final String createdTime;
  final String editedTime;

  const Note({
    this.id,
    required this.title,
    required this.contents,
    required this.regUser,
    required this.createdTime,
    required this.editedTime,
  });

  Note copy({
    int? id,
    String? title,
    String? contents,
    String? regUser,
    String? createdTime,
    String? editedTime,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        contents: contents ?? this.contents,
        regUser: regUser ?? this.regUser,
        createdTime: createdTime ?? this.createdTime,
        editedTime: editedTime ?? this.editedTime,
      );

  static Note fromJson(Map<String, Object?> json) =>
      Note(
          id: json[NoteFields.id] as int?,
          title: json[NoteFields.title] as String,
          contents: json[NoteFields.contents] as String,
          regUser: json[NoteFields.regUser] as String,
          createdTime: json[NoteFields.createdTime] as String,
          editedTime: json[NoteFields.editedTime] as String
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.contents: contents,
        NoteFields.regUser: regUser,
        NoteFields.createdTime: createdTime,
        NoteFields.editedTime: editedTime,
      };
}
