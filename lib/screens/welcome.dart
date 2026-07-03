import 'dart:ui';

import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Beshence Notes"),
      ),
      body: SizedBox.expand(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {},
        label: Text("New note"),
        icon: Icon(Icons.edit),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var selectedAccount = Beshence.selectedAccount;
      if(selectedAccount == null && mounted) {
        showDialog(
          useSafeArea: true,
          requestFocus: true,
          barrierDismissible: false,
          context: context,
          builder: (context) =>
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: AlertDialog.adaptive(
                  title: Text('Welcome to Beshence Notes!',),
                  content: Text(
                    'You can log in to synchronize your data between your devices.', style: Theme.of(context).textTheme.bodyLarge,),
                  actionsOverflowButtonSpacing: 12.0,
                  actionsAlignment: .spaceBetween,
                  icon: Icon(Icons.sticky_note_2_outlined, size: 36,),
                  actions: [
                    FilledButton.tonal(
                      onPressed: () async {
                        var account = await Beshence.createAccount();
                        Beshence.setSelectedAccount(account);
                        context.replace("/");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(

                              content: Text("Created offline account successfully."),
                              showCloseIcon: true,
                            ));
                      },
                      child: const Text('Use offline'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Add new account'),
                    ),
                  ],
                ),
              ),
        );
      }
    });
  }
}