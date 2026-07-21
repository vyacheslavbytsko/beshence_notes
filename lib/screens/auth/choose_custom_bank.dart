import 'dart:convert';

import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../misc.dart';
import 'modals.dart';

class ChooseCustomBankScreen extends StatefulWidget {
  final bool newAccount;

  const ChooseCustomBankScreen({super.key, required this.newAccount});

  @override
  State<StatefulWidget> createState() => _ChooseCustomBankScreenState();

}

class _ChooseCustomBankScreenState extends State<ChooseCustomBankScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void pingBankAndContinue() {
    processBeshenceBank(context, _controller.text, widget.newAccount);
  }

  @override
  Widget build(BuildContext context) {
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.edit_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Choose custom Bank", style: TextTheme.of(context).headlineLarge,),
          SizedBox(height: 24,),
          RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(text: "Bank is where your Vaults are stored. "),
                    TextSpan(text: "More info",
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
                    ),
                    if (!widget.newAccount) TextSpan(text: "\n\nIf your account is located on several Vaults, choose whichever Bank you prefer."),
                    // TODO: if(widget.newAccount) TextSpan(text: "\n\nWant to set up your own Bank? "),
                    // TODO: if(widget.newAccount) TextSpan(text: "Click here", style: TextStyle(color: Colors.blue))
                  ]
              )
          ),
          SizedBox(height: 24,),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Bank address',
            ),
            onSubmitted: (String value) => pingBankAndContinue(),
          ),
          SizedBox(height: 24,),
          OverflowBar(
            alignment: .end,
            overflowAlignment: .end,
            spacing: 16,
            overflowSpacing: 0,
            overflowDirection: .up,
            children: [
              FilledButton(
                onPressed: () => pingBankAndContinue(),
                child: const Text('Continue'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Future<void> processBeshenceBank(BuildContext context, String address, bool newAccount) async {
  await BeshenceBank.ping(address: address);
  context.push("${newAccount?"/register":"/login"}/login_to_bank?&address=${base64Url.encode(utf8.encode(address))}");
}