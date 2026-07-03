import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:notes/misc.dart';
import 'package:notes/route.dart';

import 'hive_registrar.g.dart';
import 'models/note_v1.dart';

Future<void> main() async {
  await Beshence.init();
  await Hive.initFlutter();
  Hive.registerAdapters();
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
