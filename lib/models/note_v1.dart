
import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:hive_ce/hive.dart';

import '../misc.dart';

part 'note_v1.g.dart';

@HiveType(typeId: 0)
class NoteV1 extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String accountId;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final DateTime? titleModifiedAt;
  @HiveField(5)
  final String text;
  @HiveField(6)
  final DateTime? textModifiedAt;
  @HiveField(7)
  final bool deleted;
  @HiveField(8)
  final DateTime? deletionStateChangedAt;

  NoteV1({
    required this.id,
    required this.accountId,
    required this.createdAt,
    required this.title,
    required this.titleModifiedAt,
    required this.text,
    required this.textModifiedAt,
    required this.deleted,
    required this.deletionStateChangedAt
  });

  static List<NoteV1> getAllNotes() {
    final account = Beshence.selectedAccount;
    return notesV1Box.values.where((note) => note.accountId == account!.id && !note.deleted).toList();
  }

  static List<NoteV1> getAllNotesSorted() {
    final notes = getAllNotes();
    notes.sort((a, b) =>
        latestDateTime([b.createdAt, b.titleModifiedAt, b.textModifiedAt])
            .compareTo(latestDateTime([a.createdAt, a.titleModifiedAt, a.textModifiedAt])
        )
    );
    return notes;
  }

  static Future<void> addNote(NoteV1 note) async {
    final account = Beshence.selectedAccount;
    await notesV1Box.put("${account!.id}_${note.id}", note);
  }

  static Future<void> updateNote(NoteV1 note) async {
    final account = Beshence.selectedAccount;
    await notesV1Box.put("${account!.id}_${note.id}", note);
  }

  static NoteV1? getNote(String id) {
    final account = Beshence.selectedAccount;
    return notesV1Box.get("${account!.id}_$id");
  }

  static int getNotesCount() {
    final account = Beshence.selectedAccount;
    return notesV1Box.values.where((note) => note.accountId == account!.id && !note.deleted).length;
  }

  static List<NoteV1> _getAllNotesIncludingDeleted() {
    final account = Beshence.selectedAccount;
    return notesV1Box.values.where((note) => note.accountId == account!.id).toList();
  }
}