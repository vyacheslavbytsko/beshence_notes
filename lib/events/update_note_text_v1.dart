import 'dart:async';

import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';

import '../misc.dart';
import '../models/note_v1.dart';

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

class UpdateNoteTextV1EventSpec implements BeshenceEventSpec<UpdateNoteTextV1Event> {
  @override
  String get name => "update_note_text_v1";

  @override
  FutureOr<void> apply(UpdateNoteTextV1Event event) async {
    final account = Beshence.selectedAccount!;
    NoteV1? note = NoteV1.getNote(event.noteId);
    if(note == null) {
      return;
    }
    if(note.textUpdatedAt?.isAfter(event.updatedAt) ?? false) {
      return;
    }
    NoteV1 updatedNote = NoteV1(
        id: note.id,
        accountId: note.accountId,
        createdAt: note.createdAt,
        title: note.title,
        titleUpdatedAt: note.titleUpdatedAt,
        text: event.text,
        textUpdatedAt: event.updatedAt,
        deleted: note.deleted,
        deletionStateChangedAt: note.deletionStateChangedAt
    );
    await notesV1Box.put("${account.id}_${note.id}", updatedNote);
    notesChangeNotifier.updateNotes();
  }

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