import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _bankAddressController;
  late TextEditingController _bankUsernameController;
  late TextEditingController _bankPasswordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: Beshence.selectedAccount!.vaults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(Beshence.selectedAccount!.vaults[index].id),
                    );
                  }
              ),
            ],
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    _bankAddressController = TextEditingController();
    _bankUsernameController = TextEditingController();
    _bankPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _bankAddressController.dispose();
    _bankUsernameController.dispose();
    _bankPasswordController.dispose();
    super.dispose();
  }
}