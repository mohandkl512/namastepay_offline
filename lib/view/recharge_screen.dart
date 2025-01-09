import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/utils/operators.dart';
import '../widgets/num_pad.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedOperator;
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
              _selectedOperator != null;
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
                _processRecharge(pinController.text);
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

  void _processRecharge(String pin) async {
    showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 2));
    // if (Utils.isPinValid(pin)) {
    //   final homeCubit = context.read<HomeCubit>();
    //   if (_selectedOperator == NT && amount != null) {
    //     await homeCubit.rechargeNamaste(pin, amount!, _phoneController.text);
    //     Navigator.pushNamed(
    //       context,
    //       RoutesName.actionCompleted,
    //     );
    //   } else if (_selectedOperator == NCELL && amount != null) {
    //     await homeCubit.rechargeNcell(pin, amount!, _phoneController.text);
    //     Navigator.pushNamed(
    //       context,
    //       RoutesName.actionCompleted,
    //     );
    //   }
    // }
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      RoutesName.actionCompleted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recharge")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Carrier Type',
              style: TextStyle(
                fontSize: 16.sp,
                // color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: [
                for (String networkOperator in operators)
                  ChoiceChip(
                    label: Text(networkOperator),
                    selected: _selectedOperator == networkOperator,
                    onSelected: (selected) {
                      setState(() {
                        _selectedOperator = selected ? networkOperator : null;
                      });
                      _validateForm();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
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
                child: const Text("Recharge"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}