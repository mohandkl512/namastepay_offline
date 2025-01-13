import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/sim_type.dart';
import 'package:ussd_npay/viewmodels/home_cubit.dart';
import 'package:ussd_npay/viewmodels/recharge_cubit.dart';
import 'package:ussd_npay/viewmodels/states/home_state.dart';

class RechargePageDialog extends StatefulWidget {
  final SimType simType;
  const RechargePageDialog({super.key, required this.simType});

  @override
  _FormDialogState createState() => _FormDialogState();
}

class _FormDialogState extends State<RechargePageDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, ServiceState>(
      listener: (context, state) {
        if (state is ServiceLoading) {
          Navigator.pop(context);
          _processingDialog(context);
        } else if (state is ServiceSelected) {
          Navigator.pop(context);
          _successDialog(context, state.serviceCode);
        } else if (state is ServiceError) {
          Navigator.pop(context);
          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[400],
                duration: const Duration(seconds: 2),
              ),
            );
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Phone number field
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validator.validatePhoneNumber,
            ),
            SizedBox(height: 16.sp),

            // PIN field
            TextFormField(
              controller: _pinController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'PIN Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator:Validator.validatePin,
            ),
            SizedBox(height: 16.sp),
            // Amount field
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validator.amountValidator,
            ),
            const SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              onPressed: () async {
                final homecubit = context.read<RechargeCubit>();
                if (_formKey.currentState?.validate() ?? false) {
                  // Process the form
                  final phoneNumber = _phoneController.text;
                  final pin = _pinController.text;
                  final amount = _amountController.text;
                  dPrint('Phone: $phoneNumber, PIN: $pin, Amount: $amount');
                  if (widget.simType == SimType.ntc) {
                    await homecubit.rechargeNamaste(
                        pin, int.parse(amount), phoneNumber);
                  } else if (widget.simType == SimType.ncell) {
                    await homecubit.rechargeNcell(
                        pin, int.parse(amount), phoneNumber);
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _processingDialog(BuildContext context) {
    showDialog(
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // The loading spinner
              SizedBox(width: 10),
              Text("processing Payment..."), // Text next to the spinner
            ],
          ),
        );
      },
    );
  }

  void _successDialog(BuildContext context, String? message) {
    showDialog(
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(
                Icons.info,
                size: 36,
                color: Colors.amber,
              ), // The loading spinner
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message ?? "Payment Could not be completed...",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ), // Text next to the spinner
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Dismiss the dialog
                // Dismiss the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
