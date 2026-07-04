import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

class UpdateNoteTextV1Event extends BeshenceEvent {
  final String noteId;
  final String text;
  final DateTime updatedAt;

  UpdateNoteTextV1Event({
    required this.noteId,
    required this.text,
    required this.updatedAt
  });
}

class UpdateNoteTextV1EventMapper implements BeshenceEventMapper<UpdateNoteTextV1Event> {
  @override
  String get name => "update_note_text_v1";

  @override
  UpdateNoteTextV1Event fromJson(Map<String, dynamic> json) {
    return UpdateNoteTextV1Event(
        noteId: json["note_id"],
        text: json["text"],
        updatedAt: DateTime.parse(json["updated_at"]));
  }

  @override
  Map<String, dynamic> toJson(UpdateNoteTextV1Event event) {
    return {
      "note_id": event.noteId,
      "text": event.text,
      "updated_at": event.updatedAt.toIso8601String()
    };
  }
}