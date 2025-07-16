import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/viewmodels/send_money_cubit.dart';
import 'package:ussd_npay/viewmodels/states/send_money_state.dart';
import 'package:ussd_npay/widgets/form_page.dart';
import 'package:ussd_npay/widgets/success_router.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  void _validateForm() {
    dPrint(_phoneController.text);
    setState(() {
      _isFormValid =
          Validator.cellPhoneNumberValidator(_phoneController.text) == null &&
              Validator.amountValidator(_amountController.text) == null;
    });
  }

  void _processRequest() async {
    final requestCubit = context.read<SendMoneyCubit>();
    await requestCubit.sendMoney(
        _phoneController.text, int.parse(_amountController.text));
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Send Money',
      formKey: _formKey,
      children: [
        const SizedBox(height: 8),
        NumberFormField.cellPhone(
          controller: _phoneController,
          labelText: 'Phone Number',
          onChanged: (value) {
            _validateForm();
          },
        ),
        const SizedBox(height: 8),
        NumberFormField.amount(
          controller: _amountController,
          labelText: 'Amount',
          onChanged: (value) {
            _validateForm();
          },
        ),
        const SizedBox(height: 32),
        SuccessRouter<SendMoneyCubit, SendMoneyState>(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                if (_isFormValid) {
                  _processRequest();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Either Phone number or amount is invalid'),
                      backgroundColor: Colors.red[400],
                      duration: const Duration(
                        seconds: 3,
                      ),
                    ),
                  );
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
                'Send Money',
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
