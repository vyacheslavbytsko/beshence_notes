import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
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

/*bool isPortrait(BuildContext context) {
  return MediaQuery.orientationOf(context) == Orientation.portrait;
}

bool isLandscape(BuildContext context) {
  return MediaQuery.orientationOf(context) == Orientation.landscape;
}

class CenteredWidget extends StatelessWidget {
  final Widget child;

  const CenteredWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
          child: Row(
            crossAxisAlignment: isLandscape(context)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Expanded(child: SizedBox.shrink()),
              SizedBox(
                width: isLandscape(context)
                    ? 384*2
                    : (constraints.maxWidth - 32),
                child: child,
              ),
              Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}*/