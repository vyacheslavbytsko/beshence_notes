import 'package:hive_ce/hive_ce.dart';

import '../misc.dart';

class NotesBoxV1 {
  static const _boxName = 'beshence_notes_notes_v1';

  final Box<Map> _notesBox;

  NotesBoxV1._create(this._notesBox);

  static Future<NotesBoxV1> create({String? directory}) async {
    final box = await openMapBox(_boxName);
    return NotesBoxV1._create(box);
  }

  List<NoteV1> getAllNotes() => _allNotes.where((note) => !note.deleted).toList();

  List<NoteV1> getAllNotesSorted() {
    final notes = getAllNotes();
    notes.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
    return notes;
  }

  void addNote(NoteV1 note) => _notesBox.put(note.id, note.toMap());

  void updateNote(NoteV1 note) => _notesBox.put(note.id, note.toMap());

  NoteV1? getNote(String id) {
    final note = _notesBox.get(id);
    if (note == null) return null;
    return NoteV1.fromMap(id: id, map: note);
  }

  int get notesLength => _notesBox.length;

  List<NoteV1> get _allNotes => _notesBox.keys
      .map((key) => NoteV1.fromMap(id: key as String, map: _notesBox.get(key)!))
      .toList();
}

class NoteV1 {
  String id;
  DateTime createdAt;
  DateTime modifiedAt;
  String? title;
  String? text;
  bool deleted;

  NoteV1({
    required this.id,
    required this.createdAt,
    required this.modifiedAt,
    required this.title,
    required this.text,
    this.deleted = false,
  });

  factory NoteV1.fromMap({
    required String id,
    required Map<dynamic, dynamic> map,
  }) {
    final normalizedMap = Map<String, dynamic>.from(map);
    return NoteV1(
      id: id,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        normalizedMap['createdAt'] as int,
      ),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(
        normalizedMap['modifiedAt'] as int,
      ),
      title: normalizedMap['title'] as String?,
      text: normalizedMap['text'] as String?,
      deleted: normalizedMap['deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'createdAt': createdAt.millisecondsSinceEpoch,
        'modifiedAt': modifiedAt.millisecondsSinceEpoch,
        'title': title,
        'text': text,
        'deleted': deleted,
      };
}
