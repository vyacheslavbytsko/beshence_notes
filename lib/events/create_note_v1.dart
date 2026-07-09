import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

class CreateNoteV1Event extends BeshenceEvent {
  final String noteId;
  final DateTime createdAt;

  CreateNoteV1Event({
    required this.noteId,
    required this.createdAt
  });
}

class CreateNoteV1EventSpec implements BeshenceEventSpec<CreateNoteV1Event> {
  @override
  String get name => "create_note_v1";

  @override
  CreateNoteV1Event fromJson(Map<String, dynamic> json) {
    return CreateNoteV1Event(
        noteId: json["note_id"],
        createdAt: DateTime.parse(json["created_at"]));
  }

  @override
  Map<String, dynamic> toJson(CreateNoteV1Event event) {
    return {
      "note_id": event.noteId,
      "created_at": event.createdAt.toIso8601String()
    };
  }
}