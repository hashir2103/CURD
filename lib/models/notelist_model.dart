class Note {
  String noteID;
  String noteTitle;
  String noteContent;
  DateTime createDateTime;
  DateTime latestEditDateTime;

  Note(
      {this.noteID,
      this.noteTitle,
      this.noteContent,
      this.createDateTime,
      this.latestEditDateTime});

  Note.fromJson(Map<String, dynamic> json)
    : noteID = json['noteID'],
      noteTitle = json['noteTitle'],
      noteContent = json['noteContent'] ?? '',
      createDateTime = DateTime.parse(json['createDateTime']),
      latestEditDateTime = json['latestEditDateTime'] ?? DateTime.now();
}
