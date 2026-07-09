import 'dart:async';

import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

class UpdateNoteTitleV1Event extends BeshenceEvent {
  final String noteId;
  final String title;
  final DateTime updatedAt;

  UpdateNoteTitleV1Event({
    required this.noteId,
    required this.title,
    required this.updatedAt
  });
}

class UpdateNoteTitleV1EventSpec implements BeshenceEventSpec<UpdateNoteTitleV1Event> {
  @override
  String get name => "update_note_title_v1";

  @override
  FutureOr<void> apply(UpdateNoteTitleV1Event event) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  UpdateNoteTitleV1Event fromJson(Map<String, dynamic> json) {
    return UpdateNoteTitleV1Event(
        noteId: json["note_id"],
        title: json["title"],
        updatedAt: DateTime.parse(json["updated_at"]));
  }

  @override
  Map<String, dynamic> toJson(UpdateNoteTitleV1Event event) {
    return {
      "note_id": event.noteId,
      "title": event.title,
      "updated_at": event.updatedAt.toIso8601String()
    };
  }
}