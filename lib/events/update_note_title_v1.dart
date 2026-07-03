import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

class UpdateNoteTitleV1Event extends BeshenceEvent<UpdateNoteTitleV1Event> {
  final String noteId;
  final String title;
  final DateTime updatedAt;

  UpdateNoteTitleV1Event({
    super.name="update_note_title_v1",
    required this.noteId,
    required this.title,
    required this.updatedAt
  });

  @override
  UpdateNoteTitleV1Event fromJson(Map<String, dynamic> json) {
    return UpdateNoteTitleV1Event(
        noteId: json["noteId"],
        title: json["title"],
        updatedAt: DateTime.parse(json["updatedAt"]));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "noteId": noteId,
      "title": title,
      "updatedAt": updatedAt.toIso8601String()
    };
  }

}