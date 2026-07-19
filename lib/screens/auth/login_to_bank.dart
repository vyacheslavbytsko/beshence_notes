import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginToBankScreen extends StatefulWidget {
  final bool newAccount;
  final String bankAddress;

  const LoginToBankScreen({super.key, required this.newAccount, required this.bankAddress});

  @override
  State<StatefulWidget> createState() => _LoginToBankScreenState();
}

class _LoginToBankScreenState extends State<LoginToBankScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}