import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/viewmodels/request_cubit.dart';
import 'package:ussd_npay/viewmodels/states/request_state.dart';
import '../routes/route_path.dart';
import '../utils/app_colors.dart';
import '../utils/npay_texts.dart';
import 'package:ussd_npay/widgets/form_page.dart';

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
          Validator.validatePhoneNumber(_phoneController.text) == null &&
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
          onChanged: (value) {
            _validateForm();
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ), // Add padding to ensure proper spacing
              child: Text(
                NpayTexts.rs, // Currency symbol or any other text
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          validator: Validator.amountValidator,
          onChanged: (value) {
            _validateForm();
          },
        ),
        const SizedBox(height: 32),
        BlocConsumer<RequestCubit, RequestState>(
          listener: (context, state) {
            switch (state) {
              case Requested _:
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.requestCompleted,
                  (_) => false,
                );
              case RequestError _:
                // showErrorDialog(context, "Error Occured", state.message);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.requestCompleted,
                  (_) => false,
                );
              case Requesting _:
                showLoadingDialog(context);
            }
          },
          builder: (context, state) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_isFormValid) {
                    _processRequest();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            "Either Phone number or amount is invalid"),
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
                  "Request Money",
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
    );
  }
}
