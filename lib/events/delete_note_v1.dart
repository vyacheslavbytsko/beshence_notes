import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

class DeleteNoteV1Event extends BeshenceEvent<DeleteNoteV1Event> {
  final String noteId;
  final DateTime deletedAt;

  DeleteNoteV1Event({
    super.name="delete_note_v1",
    required this.noteId,
    required this.deletedAt
  });

  @override
  DeleteNoteV1Event fromJson(Map<String, dynamic> json) {
    return DeleteNoteV1Event(
        noteId: json["note_id"],
        deletedAt: DateTime.parse(json["deleted_at"]));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "note_id": noteId,
      "deleted_at": deletedAt.toIso8601String()
    };
  }

}