import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

class DeleteNoteV1Event extends BeshenceEvent {
  final String noteId;
  final DateTime deletedAt;

  DeleteNoteV1Event({
    required this.noteId,
    required this.deletedAt
  });
}

class DeleteNoteV1EventSpec implements BeshenceEventSpec<DeleteNoteV1Event> {
  @override
  String get name => "delete_note_v1";

  @override
  DeleteNoteV1Event fromJson(Map<String, dynamic> json) {
    return DeleteNoteV1Event(
        noteId: json["note_id"],
        deletedAt: DateTime.parse(json["deleted_at"]));
  }

  @override
  Map<String, dynamic> toJson(DeleteNoteV1Event event) {
    return {
      "note_id": event.noteId,
      "deleted_at": event.deletedAt.toIso8601String()
    };
  }
}