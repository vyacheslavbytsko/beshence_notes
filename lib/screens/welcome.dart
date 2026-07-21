import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dialogWidth = screenWidth > 600 ? 550.0 : screenWidth * 0.85;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Beshence Notes"),
          ),
          body: SizedBox.expand(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => {},
            label: Text("New note"),
            icon: Icon(Icons.edit),
          ),
        ),
        Container(
          color: Colors.black54,
          width: double.infinity,
          height: double.infinity,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: AlertDialog.adaptive(
            constraints: BoxConstraints(maxWidth: dialogWidth),
            title: Text('Welcome to Beshence Notes!',),
            content: Text(
              'To get started, create new account or log in to existing one.', style: Theme.of(context).textTheme.bodyLarge,),
            actionsOverflowButtonSpacing: 12.0,
            actionsAlignment: .spaceBetween,
            icon: Icon(Icons.sticky_note_2_outlined, size: 36,),
            actions: [
              FilledButton.tonal(
                onPressed: () async {
                  context.push("/register");
                },
                child: const Text('Create new account'),
              ),
              FilledButton(
                onPressed: () async {
                  context.push("/login");
                },
                child: const Text('Log in'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}