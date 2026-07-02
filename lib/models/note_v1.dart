
import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:hive_ce/hive.dart';

import '../misc.dart';

part 'note_v1.g.dart';

@HiveType(typeId: 0)
class NoteV1 extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime createdAt;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final DateTime? titleModifiedAt;
  @HiveField(4)
  final String text;
  @HiveField(5)
  final DateTime? textModifiedAt;
  @HiveField(6)
  final bool deleted;
  @HiveField(7)
  final DateTime? deletionStateChangedAt;

  NoteV1({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.titleModifiedAt,
    required this.text,
    required this.textModifiedAt,
    required this.deleted,
    required this.deletionStateChangedAt
  });

  static Future<List<NoteV1>> getAllNotes() async {
    final account = await Beshence.selectedAccount;
    final Box<NoteV1> box = await getNotesV1Box(account!);
    return box.values.where((note) => !note.deleted).toList();
  }

  static Future<List<NoteV1>> getAllNotesSorted() async {
    final notes = await getAllNotes();
    notes.sort((a, b) =>
        latestDateTime([b.createdAt, b.titleModifiedAt, b.textModifiedAt])
            .compareTo(latestDateTime([a.createdAt, a.titleModifiedAt, a.textModifiedAt])
        )
    );
    return notes;
  }

  static Future<void> addNote(NoteV1 note) async {
    final account = await Beshence.selectedAccount;
    final Box<NoteV1> box = await getNotesV1Box(account!);
    box.put(note.id, note);
  }

  static Future<void> updateNote(NoteV1 note) async {
    final account = await Beshence.selectedAccount;
    final Box<NoteV1> box = await getNotesV1Box(account!);
    box.put(note.id, note);
  }

  static Future<NoteV1?> getNote(String id) async {
    final account = await Beshence.selectedAccount;
    final Box<NoteV1> box = await getNotesV1Box(account!);
    return box.get(id);
  }

  static Future<int> getNotesCount() async {
    final account = await Beshence.selectedAccount;
    final Box<NoteV1> box = await getNotesV1Box(account!);
    return box.length;
  }

  static Future<List<NoteV1>> _getAllNotes() async {
    final account = await Beshence.selectedAccount;
    final Box<NoteV1> box = await getNotesV1Box(account!);
    return box.values.toList();
  }
}