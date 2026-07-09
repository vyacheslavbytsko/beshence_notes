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
  late TextEditingController _bankIDcontroller;
  late TextEditingController _bankBaseAPIURLcontroller;
  late TextEditingController _bankRefreshController;
  late TextEditingController _bankAccessController;
  late TextEditingController _vaultIDcontroller;
  late TextEditingController _vaultPriorityController;
  late TextEditingController _accountIDcontroller;
  late TextEditingController _firstEventIDcontroller;

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
    _bankIDcontroller = TextEditingController();
    _bankBaseAPIURLcontroller = TextEditingController();
    _bankRefreshController = TextEditingController();
    _bankAccessController = TextEditingController();
    _vaultIDcontroller = TextEditingController();
    _vaultPriorityController = TextEditingController();
    _accountIDcontroller = TextEditingController();
    _firstEventIDcontroller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var selectedAccount = Beshence.selectedAccount;
      if(selectedAccount == null && mounted) {
        double screenWidth = MediaQuery.of(context).size.width;
        double dialogWidth = screenWidth > 600 ? 550.0 : screenWidth * 0.85;
        showDialog(
          useSafeArea: true,
          requestFocus: true,
          barrierDismissible: false,
          context: context,
          builder: (context) =>
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
                        Navigator.pop(context);
                        showDialog(
                          useSafeArea: true,
                          requestFocus: true,
                          barrierDismissible: false,
                          context: context,
                          builder: (context) =>
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: AlertDialog.adaptive(
                                  constraints: BoxConstraints(maxWidth: dialogWidth),
                                  title: Text('Add Beshence Vault?',),
                                  content: Text(
                                    'Keep your account data synced with Beshence Vault – '
                                        'secure remote storage for your notes and other data. '
                                        'It lets you sync notes and other account '
                                        'information across your devices.'
                                        '\n\nYou can also create an offline account '
                                        'and add a Vault later.', style: Theme.of(context).textTheme.bodyLarge,),
                                  actionsOverflowButtonSpacing: 12.0,
                                  actionsAlignment: .spaceBetween,
                                  icon: Icon(Icons.backup_outlined, size: 36,),
                                  actions: [
                                    FilledButton.tonal(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        var account = await Beshence.createAccount();
                                        Beshence.setSelectedAccount(account);
                                        context.replace("/");
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(

                                              content: Text("Created offline account successfully."),
                                              showCloseIcon: true,
                                            ));
                                      },
                                      child: const Text('Create offline account'),
                                    ),
                                    FilledButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Add Vault'),
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                      child: const Text('Create new account'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                          useSafeArea: true,
                          requestFocus: true,
                          barrierDismissible: false,
                          context: context,
                          builder: (context) =>
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: AlertDialog.adaptive(
                                  constraints: BoxConstraints(maxWidth: dialogWidth),
                                  title: Text('Write down these parameters',),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: .start,
                                    children: [
                                      Text(
                                        'I was too lazy to program this.', style: Theme.of(context).textTheme.bodyLarge,),
                                      TextField(
                                        controller: _bankIDcontroller,
                                          decoration: InputDecoration(hint: Text("Bank ID"))
                                      ),
                                      TextField(
                                        controller: _bankBaseAPIURLcontroller,
                                          decoration: InputDecoration(hint: Text("Bank Base API URL"))
                                      ),
                                      TextField(
                                        controller: _bankRefreshController,
                                          decoration: InputDecoration(hint: Text("Bank refresh token"))
                                      ),
                                      TextField(
                                        controller: _bankAccessController,
                                          decoration: InputDecoration(hint: Text("Bank access token"))
                                      ),
                                      TextField(
                                        controller: _vaultIDcontroller,
                                          decoration: InputDecoration(hint: Text("Vault ID"))
                                      ),
                                      TextField(
                                          controller: _vaultPriorityController,
                                          decoration: InputDecoration(hint: Text("Vault priority"))
                                      ),
                                      TextField(
                                        controller: _accountIDcontroller,
                                          decoration: InputDecoration(hint: Text("Account ID"))
                                      ),
                                      TextField(
                                        controller: _firstEventIDcontroller,
                                          decoration: InputDecoration(hint: Text("First Event ID in Main Chain"))
                                      ),
                                    ],
                                  ),
                                  actionsOverflowButtonSpacing: 12.0,
                                  actionsAlignment: .spaceBetween,
                                  icon: Icon(Icons.backup_outlined, size: 36,),
                                  actions: [
                                    FilledButton(
                                      onPressed: () async {
                                        BeshenceAccount account = await Beshence.createAccount(
                                          id: _accountIDcontroller.text,
                                          initAccountEvent: false
                                        );
                                        await Beshence.setSelectedAccount(account);

                                        await Beshence.selectedAccount!.addVault(
                                          address: _bankBaseAPIURLcontroller.text,
                                          vaultId: _vaultIDcontroller.text,
                                          bankId: _bankIDcontroller.text,
                                          priority: int.tryParse(_vaultPriorityController.text) ?? 1024,
                                          refreshToken: _bankRefreshController.text,
                                          accessToken: _bankAccessController.text,
                                          addVaultEvent: false
                                        );

                                        await account.requireChain("main");
                                        await account.requireChain("notes");

                                        Navigator.pop(context);
                                        context.replace("/");
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Logged in successfully."),
                                              showCloseIcon: true,
                                            ));
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                      child: const Text('Log in'),
                    ),
                  ],
                ),
              ),
        );
      }
    });
  }

  @override
  void dispose() {
    _bankIDcontroller.dispose();
    _bankBaseAPIURLcontroller.dispose();
    _bankRefreshController.dispose();
    _bankAccessController.dispose();
    _vaultIDcontroller.dispose();
    _vaultPriorityController.dispose();
    _accountIDcontroller.dispose();
    _firstEventIDcontroller.dispose();
    super.dispose();
  }
}