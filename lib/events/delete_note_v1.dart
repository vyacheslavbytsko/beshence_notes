import 'dart:async';

import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

import '../misc.dart';
import '../models/note_v1.dart';

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
  FutureOr<void> apply(DeleteNoteV1Event event) async {
    final account = Beshence.selectedAccount!;
    NoteV1? note = NoteV1.getNote(event.noteId);
    if(note == null) {
      return;
    }
    NoteV1 deletedNote = NoteV1(
        id: note.id,
        accountId: note.accountId,
        createdAt: note.createdAt,
        title: note.title,
        titleUpdatedAt: note.titleUpdatedAt,
        text: note.text,
        textUpdatedAt: note.textUpdatedAt,
        deleted: true,
        deletionStateChangedAt: event.deletedAt
    );
    await notesV1Box.put("${account.id}_${note.id}", deletedNote);
    notesChangeNotifier.updateNotes();
  }

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