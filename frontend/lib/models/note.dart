class Note {
  final int id;
  final String title;
  final String filename;
  final String contentText;
  final String createdAt;

  Note({
    required this.id,
    required this.title,
    required this.filename,
    required this.contentText,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      contentText: json['content_text'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'filename': filename,
      'content_text': contentText,
      'created_at': createdAt,
    };
  }
}
