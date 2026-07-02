import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

Future<Box<Map>> openMapBox(String name) async => await Hive.openBox<Map>(name);

class NotesChangeNotifier extends ChangeNotifier {
  void updateNotes() {
    notifyListeners();
  }
}

NotesChangeNotifier notesChangeNotifier = NotesChangeNotifier();

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