import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/viewmodels/cashout_cubit.dart';
import 'package:ussd_npay/viewmodels/states/cashout_state.dart';
import 'package:ussd_npay/widgets/success_router.dart';
import 'package:ussd_npay/widgets/form_page.dart';

class CashoutPage extends StatefulWidget {
  const CashoutPage({super.key});

  @override
  State<CashoutPage> createState() => _CashoutPageState();
}

class _CashoutPageState extends State<CashoutPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    _formKey.currentState?.validate();

    setState(() {
      _isFormValid =
          Validator.cellPhoneNumberValidator(_phoneController.text) == null &&
              Validator.amountValidator(_amountController.text) == null;
    });
  }

  void _processCashout() async {
    if (mounted) {
      final cashoutCubit = context.read<CashoutCubit>();
      await cashoutCubit.processCashout(
          _phoneController.text, int.parse(_amountController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Cash Out',
      formKey: _formKey,
      children: [
        const SizedBox(height: 8),
        NumberFormField.cellPhone(
          controller: _phoneController,
          labelText: 'Agent Phone Number',
          onChanged: (value) {
            _formKey.currentState?.validate();
          },
        ),
        NumberFormField.amount(
          controller: _amountController,
          labelText: 'Amount: Minimum Rs.100',
          onChanged: (value) {
            _validateForm();
          },
        ),
        const SizedBox(height: 32),
        SuccessRouter<CashoutCubit, CashoutState>(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                if (_isFormValid) {
                  if (int.parse(_amountController.text) >= 100) {
                    _processCashout();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Enter amount more than 90"),
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
                "Proceed to Cashout",
                style: _isFormValid
                    ? Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.white)
                    : Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
