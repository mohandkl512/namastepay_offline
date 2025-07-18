// Statements Page (Feature in Progress)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';

import '../authentication_provider.dart';
import '../main.dart';
import '../utils/debug_print.dart';
import '../viewmodels/states/verification_state.dart';

class StatementsPage extends StatefulWidget {
  const StatementsPage({super.key});

  @override
  State<StatementsPage> createState() => _StatementsPageState();
}

class _StatementsPageState extends State<StatementsPage> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 1)).then(_viewStatements);
  }

  _viewStatements() async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    Verified verified = authProvider.authState as Verified;
    showLoadingDialog(context);
    try {
      if (authProvider.authState is Verified) {
        String requestMoneycode = UssdMethods.statements(verified.pin);
        String? response = await UssdAdvanced.sendAdvancedUssd(
          code: requestMoneycode,
          subscriptionId: verified.subscriptionId,
        );
        dPrint(response);
        Navigator.pop(context);
      }
    } on PlatformException catch (exception) {
      dPrint(exception.details);
      dPrint(exception.message);
      dPrint(exception.code);
      Navigator.pop(context);
    } on TimeoutException catch (exception) {
      dPrint(exception);
      Navigator.pop(context);
    } on MissingPluginException catch (exception) {
      dPrint(exception);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: _viewStatements,
            child: const Icon(
              Icons.assignment,
              size: 60,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Statements',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Icon(
            Icons.lock,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'Feature in Progress',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
