import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/viewmodels/landline_cubit.dart';
import 'package:ussd_npay/viewmodels/states/landline_recharge_state.dart';
import '../routes/route_path.dart';
import '../utils/app_colors.dart';
import '../utils/field_validator.dart';
import '../utils/npay_texts.dart';
import 'package:ussd_npay/widgets/form_page.dart';

class LandlineRechargePage extends StatefulWidget {
  const LandlineRechargePage({super.key});

  @override
  State<LandlineRechargePage> createState() => _LandlineRechargePageState();
}

class _LandlineRechargePageState extends State<LandlineRechargePage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  void _validateForm() {
    setState(() {
      _isFormValid = Utils.isValidLandline(_phoneController.text) &&
          Validator.amountValidator(_amountController.text) == null;
    });
  }

  void _processRequest() async {
    final requestCubit = context.read<LandlineCubit>();
    await requestCubit.payBill(
        int.parse(_amountController.text), _phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Landline Recharge',
      formKey: _formKey,
      children: [
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 9,
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
              ),
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
        BlocConsumer<LandlineCubit, LandlineRechargeState>(
          listener: (context, state) {
            switch(state) {
              case LandlineRechargeSelected _:
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.landlineSucess,
                  (_) => false,
                );
              case LandlineError _:
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.landlineSucess,
                  (_) => false,
                );
              case LandlineRecharging _:
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
                            "Either Landline number or amount is invalid"),
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
                  "Recharge",
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
