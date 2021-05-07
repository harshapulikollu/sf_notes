class Note {
  final String title;
  final String description;
  final String createdUserId;
  final int createdAt;
  final int modifiedAt;
  final String imageUrl;
  final String noteId;

  Note(
      {this.title,
      this.description,
      this.createdUserId,
      this.createdAt,
      this.modifiedAt,
      this.imageUrl,
      this.noteId});

  Note.fromJson(Map<String, dynamic> unParsedJson, String id)
      : title = unParsedJson['title'] ?? '',
        description = unParsedJson['description'] ?? '',
        createdAt =
            unParsedJson['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
        createdUserId = unParsedJson['createdUserId'] ?? '',
        modifiedAt =
            unParsedJson['modifiedAt'] ?? DateTime.now().millisecondsSinceEpoch,
        imageUrl = unParsedJson['imageUrl'] ?? '',
        noteId = id;
}
