class JournalEntry {
  int? id;
  String title;
  String content;
  String? imagePath;
  String date;

  JournalEntry({
    this.id,
    required this.title,
    required this.content,
    this.imagePath,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'date': date,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imagePath: map['imagePath'],
      date: map['date'],
    );
  }
}
