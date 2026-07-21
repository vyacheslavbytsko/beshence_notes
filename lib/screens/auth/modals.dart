import 'package:flutter/material.dart';

class WhatIsBeshenceModal extends StatelessWidget {
  const WhatIsBeshenceModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Lotta Beshence...", style: TextTheme.of(context).headlineLarge,),
                SizedBox(height: 8,),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.hub_outlined),
                  title: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(text: "Beshence", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " is an open ecosystem built around the principle that users should own their data."),
                            /*TextSpan(text: " The crucial parts are "),
                            TextSpan(text: "Beshence Bank", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " and "),
                            TextSpan(text: "Beshence Vault", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "."),*/
                          ]
                      )
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.dns_outlined),
                  title: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(text: "Beshence Bank", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " is a software to create and manage "),
                            TextSpan(text: "Beshence Vaults", style: TextStyle(fontWeight: FontWeight.bold)),
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
                            TextSpan(text: "Beshence Vault", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " is a storage for "),
                            TextSpan(text: "Beshence Account", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " and its data (notes, tasks, contacts, media, anything you can imagine)."),
                          ]
                      )
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.cloud_sync_outlined),
                  title: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(text: "Vaults allow users like you to "),
                            TextSpan(text: "back up", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " account data and "),
                            TextSpan(text: "sync", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " it between devices."),
                          ]
                      )
                  ),
                ),
                /*ListTile(
                  contentPadding: EdgeInsets.all(0),
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.shield_outlined),
                  title: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(
                                text: "You can choose whether to store your data encrypted or not."),
                          ]
                      )
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.flare),
                  title: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(text: "Possibilites are limitless:\n"),
                            TextSpan(text: "• One Beshence Account can belong to multiple Vaults therefore multiple Banks. Your account essentially can be decentralized.\n"),
                            TextSpan(text: "• You can run your own Beshence Bank on your server or even on your computer.\n"),
                            TextSpan(text: "• You can also create multiple Vaults for multiple Accounts in one particular Bank for yourself, your friends or relatives.")
                          ]
                      )
                  ),
                ),*/
                SizedBox(height: 8,),
                OverflowBar(
                    alignment: .end,
                    overflowAlignment: .end,
                    children: [
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Thanks!'),
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