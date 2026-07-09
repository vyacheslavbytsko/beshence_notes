import 'dart:async';

import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

import '../misc.dart';
import '../models/note_v1.dart';

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
  FutureOr<void> apply(UpdateNoteTitleV1Event event) async {
    final account = Beshence.selectedAccount!;
    NoteV1? note = NoteV1.getNote(event.noteId);
    if(note == null) {
      return;
    }
    if(note.titleUpdatedAt?.isAfter(event.updatedAt) ?? false) {
      return;
    }
    NoteV1 updatedNote = NoteV1(
        id: note.id,
        accountId: note.accountId,
        createdAt: note.createdAt,
        title: event.title,
        titleUpdatedAt: event.updatedAt,
        text: note.text,
        textUpdatedAt: note.textUpdatedAt,
        deleted: note.deleted,
        deletionStateChangedAt: note.deletionStateChangedAt
    );
    await notesV1Box.put("${account.id}_${note.id}", updatedNote);
    notesChangeNotifier.updateNotes();
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