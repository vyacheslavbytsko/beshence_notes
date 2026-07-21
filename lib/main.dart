import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:notes/events/create_note_v1.dart';
import 'package:notes/events/delete_note_v1.dart';
import 'package:notes/events/update_note_text_v1.dart';
import 'package:notes/events/update_note_title_v1.dart';
import 'package:notes/misc.dart';
import 'package:notes/route.dart';

import 'hive_registrar.g.dart';
import 'models/note_v1.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapters();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  BeshenceEventRegistry registry = BeshenceEventRegistry();
  registry.register<CreateNoteV1Event>(CreateNoteV1EventSpec());
  registry.register<DeleteNoteV1Event>(DeleteNoteV1EventSpec());
  registry.register<UpdateNoteTitleV1Event>(UpdateNoteTitleV1EventSpec());
  registry.register<UpdateNoteTextV1Event>(UpdateNoteTextV1EventSpec());
  await Beshence.init(registry);

  notesV1Box = await getBox<NoteV1>('beshence_notes_notes_v1');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      final lightColorScheme = lightDynamic?.harmonized() ??
          ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light
          );
      final darkColorScheme = darkDynamic?.harmonized() ??
          ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          );

      return MaterialApp.router(
        routerConfig: router,
        title: 'Beshence Notes',
        theme: ThemeData(
          colorScheme: lightColorScheme,
          appBarTheme: AppBarTheme(backgroundColor: lightColorScheme.surface),
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          appBarTheme: AppBarTheme(backgroundColor: darkColorScheme.surface),
        ),
        themeMode: ThemeMode.system
      );
    });
  }
}
