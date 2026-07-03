import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/screens/home.dart';
import 'package:notes/screens/note.dart';
import 'package:notes/screens/settings.dart';
import 'package:notes/screens/welcome.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/welcome",
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'note/:noteId',
          builder: (context, state) => NoteScreen(
            noteId: state.pathParameters['noteId']!,
          )
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) {
            return const SettingsScreen();
          },
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final selectedAccount = Beshence.selectedAccount;
    final location = state.uri.path;

    if (selectedAccount == null) {
      if (location != '/welcome') {
        return "/welcome";
      }
    } else {
      if (location == '/welcome') {
        return "/";
      }
    }
    return null;
  },
);