import 'dart:ui';

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
              TextButton(
                  child: Text("Add vault"),
                  onPressed: () => showDialog(
                      useSafeArea: true,
                      requestFocus: true,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: AlertDialog.adaptive(
                            content: Column(
                              children: [
                                Text("First, write the address of bank where you vault is in"),
                                TextField(
                                    controller: _bankAddressController
                                ),
                                TextButton(
                                  child: Text("Continue"),
                                  onPressed: () async {
                                    var pingBankResponse = await Beshence.pingBank(id: _bankAddressController.text);
                                    if(pingBankResponse.loginMethods.contains("usernameAndPassword")) {
                                      Navigator.pop(context);
                                      showDialog(
                                        useSafeArea: true,
                                        requestFocus: true,
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                            child: AlertDialog.adaptive(
                                                content: Column(
                                                  children: [
                                                    Text("Log in"),
                                                    TextField(
                                                      controller: _bankUsernameController,
                                                    ),
                                                    TextField(
                                                      controller: _bankPasswordController,
                                                      obscureText: true,
                                                    ),
                                                    TextButton(child: Text("Continue"),
                                                        onPressed: () async {
                                                          var loginBankResponse = await Beshence.loginToBank(
                                                              address: _bankAddressController.text,
                                                              username: _bankUsernameController.text,
                                                              password: _bankPasswordController.text);

                                                          List<Map<String, String>> vaults = (await Beshence.getVaultsOfBank(
                                                              address: _bankAddressController.text,
                                                              accessToken: loginBankResponse.accessToken
                                                          )).vaults;

                                                          Navigator.pop(context);
                                                          showDialog(
                                                            useSafeArea: true,
                                                            requestFocus: true,
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (context) => BackdropFilter(
                                                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                                child: AlertDialog.adaptive(
                                                                    content: Container(
                                                                      width: double.maxFinite,
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text("Choose vault"),
                                                                          // TODO: add priority text field
                                                                          Expanded(
                                                                            child: ListView.builder(
                                                                                shrinkWrap: true,
                                                                                itemCount: vaults.length,
                                                                                itemBuilder: (context, index) {
                                                                                  return ListTile(
                                                                                    title: Text(vaults[index]['name']!),
                                                                                    onTap: () {
                                                                                      Beshence.selectedAccount!.addVault(
                                                                                        address: _bankAddressController.text,
                                                                                        vaultId: vaults[index]['id']!,
                                                                                        bankId: pingBankResponse.bankId,
                                                                                        priority: 1024,
                                                                                        refreshToken: loginBankResponse.refreshToken,
                                                                                        accessToken: loginBankResponse.accessToken,
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  );
                                                                                }
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                )
                                                            ),
                                                          );
                                                        })
                                                  ],
                                                )
                                            )
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                      )
                  )
              )
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