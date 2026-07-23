import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dialogWidth = screenWidth > 600 ? 560.0 : screenWidth * 0.85;
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
              'To get started, register new Beshence Account or log in to existing one.', style: Theme.of(context).textTheme.bodyLarge,),
            actionsOverflowButtonSpacing: 8.0,
            actionsAlignment: .spaceBetween,
            icon: Icon(Icons.sticky_note_2_outlined, size: 36,),
            actionsOverflowDirection: .up,
            actions: [
              TextButton(
                onPressed: () => showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => OfflineModal()
                ),
                child: const Text('Continue offline'),
              ),
              FilledButton(
                onPressed: () async {
                  final Uri url = Uri.parse('https://account.beshence.com');
                  if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                  }
                },
                child: const Text('Register / Log in'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OfflineModal extends StatelessWidget {
  const OfflineModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Continue offline?", style: TextTheme.of(context).headlineLarge,),
                SizedBox(height: 8,),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.cloud_off),
                  title: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(text: "We'll create an "),
                            TextSpan(text: "offline Beshence Account", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ". It's the same Account but it will be available "),
                            TextSpan(text: "only in this app", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline,)),
                            TextSpan(text: ", not in any else, and it won't be backed up to any Beshence Vaults."),
                          ]
                      )
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.heart_broken_outlined),
                  title: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(text: "In case of device breaking, accidental data removal (common in web browsers) or malicious attack "),
                            TextSpan(text: "you won't be able to restore your data", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "."),
                          ]
                      )
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.dataset_outlined),
                  title: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(text: "You will be able to make this Account online by connecting it to at least one Vault."),
                          ]
                      )
                  ),
                ),
                SizedBox(height: 8,),
                OverflowBar(
                    alignment: .spaceBetween,
                    overflowAlignment: .end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Continue'),
                      )
                    ]
                )
              ],
            ),
          ),
        )
    );
  }
}