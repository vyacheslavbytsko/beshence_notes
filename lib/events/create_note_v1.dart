import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

class CreateNoteV1Event extends BeshenceEvent<CreateNoteV1Event> {
  final String noteId;
  final DateTime createdAt;

  CreateNoteV1Event({
    super.name="create_note_v1",
    required this.noteId,
    required this.createdAt
  });

  @override
  CreateNoteV1Event fromJson(Map<String, dynamic> json) {
    return CreateNoteV1Event(
        noteId: json["note_id"],
        createdAt: DateTime.parse(json["created_at"]));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "note_id": noteId,
      "created_at": createdAt.toIso8601String()
    };
  }

}