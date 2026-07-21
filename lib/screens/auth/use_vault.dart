import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/screens/auth/modals.dart';

import '../../misc.dart';

class UseVaultScreen extends StatefulWidget {
  const UseVaultScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UseVaultScreenState();
}

class _UseVaultScreenState extends State<UseVaultScreen> {
  @override
  Widget build(BuildContext context) {
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: .start,
        children: [
          Icon(Icons.cloud_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Create online account?", style: TextTheme.of(context).headlineLarge,),
          SizedBox(height: 24,),
          RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(text: "You'll be prompted to log in or register your "),
                    TextSpan(text: "Beshence Bank", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " account and choose or create "),
                    TextSpan(text: "Beshence Vault", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ". "),
                    TextSpan(text: "What are those?",
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => WhatIsBeshenceModal()
                          );
                        }
                    )
                  ]
              )
          ),
          SizedBox(height: 24,),
          OverflowBar(
            alignment: .spaceBetween,
            overflowAlignment: .end,
            spacing: 16,
            overflowSpacing: 0,
            overflowDirection: .up,
            children: [
              TextButton(
                onPressed: () async {
                  var account = await Beshence.createAccount();
                  Beshence.setSelectedAccount(account);
                  context.go("/");
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Created offline account successfully."),
                        showCloseIcon: true,
                      ));
                },
                child: const Text('Create offline account'),
              ),
              FilledButton(
                onPressed: () => context.push("/register/choose_bank"),
                child: const Text('Create online account'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

