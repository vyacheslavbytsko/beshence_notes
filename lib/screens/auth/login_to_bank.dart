import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../misc.dart';

class LoginToBankScreen extends StatefulWidget {
  final bool newAccount;
  final String bankAddress;

  const LoginToBankScreen({super.key, required this.newAccount, required this.bankAddress});

  @override
  State<StatefulWidget> createState() => _LoginToBankScreenState();
}

class _LoginToBankScreenState extends State<LoginToBankScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: .start,
        children: [
          Icon(Icons.dns_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Login to Bank", style: TextTheme.of(context).headlineLarge,),
          SizedBox(height: 24,),
          FutureBuilder(future: BeshenceBank.ping(address: widget.bankAddress), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              List<String> loginMethods = snapshot.requireData.loginMethods;
              return Column(
                children: [
                  if(loginMethods.contains("usernameAndPassword")) ...[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      controller: _usernameController,
                      enabled: _enabled,
                    ),
                    SizedBox(height: 16,),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      enabled: _enabled,
                    ),
                    SizedBox(height: 24,),
                  ]
                ]
              );
            }
          }),
          SizedBox(height: 24,),
          OverflowBar(
            alignment: widget.newAccount ? .spaceBetween : .end,
            overflowAlignment: .end,
            spacing: 16,
            overflowSpacing: 0,
            overflowDirection: .up,
            children: [
              if(widget.newAccount) TextButton(
                onPressed: !_enabled ? null : () => context.push("/register/register_in_bank"),
                child: const Text('Register instead'),
              ),
              FilledButton(
                onPressed: !_enabled ? null : () {
                  setState(() {
                    _enabled = false;
                  });
                },
                child: const Text('Log in'),
              ),
            ],
          )
        ],
      ),
    );
  }
}