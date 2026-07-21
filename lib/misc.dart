import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
}

class CenteredScaffold extends StatelessWidget {
  final Widget body;

  const CenteredScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    var surfaceContainer = Theme.of(context).colorScheme.surfaceContainer;
    var surface = Theme.of(context).colorScheme.surface;
    return Scaffold(
        backgroundColor: isLandscape(context) ? surfaceContainer : surface,
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: isLandscape(context) ? AlignmentGeometry.center : AlignmentGeometry.topCenter,
                child: LayoutBuilder(builder: (context, constraints) {
                  return Padding(
                    padding: isLandscape(context) ? const EdgeInsets.symmetric(horizontal: 32.0) : const EdgeInsets.all(0.0),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 640
                        ),
                        child: Column(
                          mainAxisSize: .min,
                          children: [
                            SizedBox(height: 56,),
                            Card.filled(
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(32),
                              ),
                              margin: .all(0.0),
                              color: Theme.of(context).colorScheme.surface,
                              child: Padding(
                                padding: .all(32.0),
                                child: body,
                              ),
                            ),
                            SizedBox(height: 56,)
                          ],
                        ),
                      ),
                    ),
                  );
                },)
              ),
              SizedBox(
                height: 56,
                child: AppBar(
                    scrolledUnderElevation: 0.0,
                    leading: !context.canPop() ? null : Padding(
                        padding: EdgeInsetsGeometry.all(8.0),
                      child: IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              isLandscape(context)
                              ? Theme.of(context).colorScheme.surfaceContainer
                              : Theme.of(context).colorScheme.surface
                          )
                        ),
                          onPressed: () => context.pop(),
                          icon: Icon(Icons.arrow_back)),
                    ),
                  backgroundColor: Colors.transparent
                ),
              )
            ],
          ),
        )
    );
  }
}