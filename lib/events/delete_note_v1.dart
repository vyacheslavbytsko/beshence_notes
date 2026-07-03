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
        noteId: json["noteId"],
        deletedAt: DateTime.parse(json["deletedAt"]));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "noteId": noteId,
      "deletedAt": deletedAt.toIso8601String()
    };
  }

}