import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/utils/operators.dart';
import '../viewmodels/home_cubit.dart';
import '../widgets/num_pad.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isFormValid = false;
  int? amount;

  // List of available network operators
  final List<String> operators = [NT, NCELL];
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          Validator.validatePhoneNumber(_phoneController.text) == null &&
              amount != null;
    });
  }

  void _showPinDialog() {
    TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Enter PIN"),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              bool validPin = Utils.isPinValid(pinController.text);
              if (validPin) {
                Navigator.pop(context);
                _processRequest(pinController.text);
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Invalid Pin"),
                    backgroundColor: Colors.red[400],
                    duration: const Duration(
                      seconds: 2,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text("Proceed"),
          ),
        ],
      ),
    );
  }

  void _processRequest(String pin) async {
    showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      if (Utils.isPinValid(pin) && amount != null) {
        final homeCubit = context.read<HomeCubit>();
        await homeCubit.sendMoney(_phoneController.text, amount!, pin);
        if (mounted) {
          Navigator.pushNamed(
            context,
            RoutesName.actionCompleted,
          );
        }
      }
      if (mounted) {
        
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          RoutesName.actionCompleted,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Money")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomNumberPad(
              onSubmit: (a) {
                amount = a;
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _isFormValid ? _showPinDialog : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: _isFormValid ? Colors.blue : Colors.grey,
                ),
                child: const Text("Send Money"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
