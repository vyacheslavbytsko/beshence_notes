import 'dart:convert';

import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/screens/auth/choose_bank.dart';
import 'package:notes/screens/auth/choose_custom_bank.dart';
import 'package:notes/screens/auth/login_to_bank.dart';
import 'package:notes/screens/auth/use_vault.dart';
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
          path: '/note/:noteId',
          builder: (context, state) => NoteScreen(
            noteId: state.pathParameters['noteId']!,
          )
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) {
            return const SettingsScreen();
          },
        ),
      ],
    ),
    GoRoute(
        path: "/login",
        redirect: (context, state) => state.uri.path == "/login" ? "/login/choose_bank" : null,
        routes: [
          GoRoute(path: "/choose_bank", builder: (context, state) => const ChooseBankScreen(newAccount: false)),
          GoRoute(path: "/choose_custom_bank", builder: (context, state) => const ChooseCustomBankScreen(newAccount: false)),
          GoRoute(path: "/login_to_bank", builder: (context, state) => LoginToBankScreen(newAccount: false, bankAddress: utf8.decode(base64Url.decode(state.uri.queryParameters['address']!))))
        ]
    ),
    GoRoute(
        path: "/register",
        redirect: (context, state) => state.uri.path == "/register" ? "/register/use_vault" : null,
        routes: [
          GoRoute(path: "/use_vault", builder: (context, state) => const UseVaultScreen()),
          GoRoute(path: "/choose_bank", builder: (context, state) => const ChooseBankScreen(newAccount: true)),
          GoRoute(path: "/choose_custom_bank", builder: (context, state) => const ChooseCustomBankScreen(newAccount: true)),
          GoRoute(path: "/login_to_bank", builder: (context, state) => LoginToBankScreen(newAccount: true, bankAddress: utf8.decode(base64Url.decode(state.uri.queryParameters['address']!))))
        ]
    ),
  ],
  redirect: (context, state) {
    final selectedAccount = Beshence.selectedAccount;
    final location = state.uri.path;

    if (selectedAccount == null) {
      if (location != '/welcome' && !location.startsWith('/login') && !location.startsWith('/register')) {
        return "/welcome";
      }
    } else {
      if (location == '/welcome') {
        return "/";
      }
    }

    if(location == "/login") return "/login/choose_bank";
    if(location == "/register") return "/register/use_vault";

    return null;
  },
);