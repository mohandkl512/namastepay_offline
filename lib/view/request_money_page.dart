import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/viewmodels/request_cubit.dart';
import 'package:ussd_npay/viewmodels/states/request_state.dart';
import 'package:ussd_npay/widgets/success_router.dart';
import 'package:ussd_npay/widgets/form_page.dart';

import '../utils/app_colors.dart';

class RequestMoneyScreen extends StatefulWidget {
  const RequestMoneyScreen({super.key});

  @override
  State<RequestMoneyScreen> createState() => _RequestMoneyScreenState();
}

class _RequestMoneyScreenState extends State<RequestMoneyScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  void _validateForm() {
    setState(() {
      _isFormValid =
          Validator.cellPhoneNumberValidator(_phoneController.text) == null &&
              Validator.amountValidator(_amountController.text) == null;
    });
  }

  void _processRequest() async {
    final requestCubit = context.read<RequestCubit>();
    await requestCubit.requestMoney(
        _phoneController.text, int.parse(_amountController.text));
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Request Money',
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
        SuccessRouter<RequestCubit, RequestState>(
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
                'Request Money',
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
