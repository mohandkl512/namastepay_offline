import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/utils/npay_texts.dart';
import 'package:ussd_npay/viewmodels/internal_remit_cubit.dart';
import 'package:ussd_npay/viewmodels/states/internal_remit_state.dart';
import '../utils/error_dialog.dart';

class InternalRemit extends StatefulWidget {
  const InternalRemit({super.key});

  @override
  _InternalRemitState createState() => _InternalRemitState();
}

class _InternalRemitState extends State<InternalRemit> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  // List of available network operators

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    _formKey.currentState?.validate();

    setState(() {
      _isFormValid =
          Validator.validatePhoneNumber(_phoneController.text) == null &&
              Validator.amountValidator(_amountController.text) == null;
    });
  }

  void _processRemit() async {
    if (mounted) {
      final cashoutCubit = context.read<InternalRemitCubit>();
      await cashoutCubit.processInternalRemit(
        _phoneController.text,
        int.parse(_amountController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Internal Remit",
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: Validator.validatePhoneNumber,
                onChanged: (value) {
                  _formKey.currentState?.validate();
                },
                decoration: InputDecoration(
                  labelText: "Receiver Phone Number(Unregistered)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount: Minimum Rs.100',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ), // Add padding to ensure proper spacing
                    child: Text(
                      NpayTexts.rs, // Currency symbol or any other text
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: Validator.amountValidator,
                onChanged: (value) {
                  _validateForm();
                },
              ),
              const SizedBox(height: 32),
              BlocConsumer<InternalRemitCubit, InternalRemitState>(
                listener: (context, state) {
                  dPrint("Current State: $state");
                  if (state is RemitDone) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.remitSucess,
                      (_) => false,
                    );
                  } else if (state is RemitError) {
                    showErrorDialog(context, "Error Occured", state.message);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.remitSucess,
                      (_) => false,
                    );
                  } else if (state is RemitProcessing) {
                    showLoadingDialog(context);
                  }
                },
                builder: (BuildContext context, InternalRemitState state) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isFormValid) {
                          if (int.parse(_amountController.text) >= 100) {
                            _processRemit();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text("Enter amount more than 90"),
                                backgroundColor: Colors.red[400],
                                duration: const Duration(
                                  seconds: 3,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: _isFormValid
                            ? AppColors.buttonColor
                            : AppColors.accentColor,
                      ),
                      child: Text(
                        "Send Money",
                        style: _isFormValid
                            ? Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.white)
                            : Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
