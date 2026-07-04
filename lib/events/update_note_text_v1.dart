import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

class UpdateNoteTextV1Event extends BeshenceEvent<UpdateNoteTextV1Event> {
  final String noteId;
  final String text;
  final DateTime updatedAt;

  UpdateNoteTextV1Event({
    super.name="update_note_text_v1",
    required this.noteId,
    required this.text,
    required this.updatedAt
  });

  @override
  UpdateNoteTextV1Event fromJson(Map<String, dynamic> json) {
    return UpdateNoteTextV1Event(
        noteId: json["note_id"],
        text: json["text"],
        updatedAt: DateTime.parse(json["updated_at"]));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "note_id": noteId,
      "text": text,
      "updated_at": updatedAt.toIso8601String()
    };
  }

}