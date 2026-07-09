import 'dart:async';

import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:notes/misc.dart';

import '../models/note_v1.dart';

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
  FutureOr<void> apply(CreateNoteV1Event event) async {
    if(NoteV1.getAllNotes().any((note) => note.id == event.noteId)) {
      return;
    }
    NoteV1 note = NoteV1(
        id: event.noteId,
        accountId: event.account!.id,
        createdAt: event.createdAt,
        title: "",
        titleUpdatedAt: null,
        text: "",
        textUpdatedAt: null,
        deleted: false,
        deletionStateChangedAt: null
    );
    await NoteV1.addNote(note);
    notesChangeNotifier.updateNotes();
  }

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