import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import 'models/note_v1.dart';

late final Box<NoteV1> notesV1Box;

class NotesChangeNotifier extends ChangeNotifier {
  void updateNotes() {
    notifyListeners();
  }
}

NotesChangeNotifier notesChangeNotifier = NotesChangeNotifier();

Future<Box<T>> getBox<T>(String name) async =>
    Hive.isBoxOpen(name)
        ? Hive.box<T>(name)
        : await Hive.openBox<T>(name);

late final Box<NoteV1> notesV1box;

DateTime latestDateTime(List<DateTime?> dateTimes) {
  DateTime latestDateTime = dateTimes.nonNulls.reduce((a, b) => a.isAfter(b) ? a : b);
  return latestDateTime;
}

bool isLandscape(BuildContext context) {
  return MediaQuery.widthOf(context) > 640;
  // return MediaQuery.orientationOf(context) == Orientation.landscape;
}

class CenteredWidget extends StatelessWidget {
  final Widget child;

  const CenteredWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 128),
          child: Row(
            crossAxisAlignment: isLandscape(context)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Expanded(child: SizedBox.shrink()),
              SizedBox(
                width: isLandscape(context)
                    ? min(640, constraints.maxWidth - 48)
                    : (constraints.maxWidth - 48),
                child: child,
              ),
              Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}