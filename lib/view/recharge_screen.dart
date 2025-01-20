import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/utils/npay_texts.dart';
import 'package:ussd_npay/utils/operators.dart';
import 'package:ussd_npay/viewmodels/recharge_cubit.dart';
import 'package:ussd_npay/viewmodels/states/recharge_state.dart';
import '../utils/error_dialog.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedOperator;
  bool _isFormValid = false;

  // List of available network operators
  final List<String> operators = [MNO.nt, MNO.ncell];
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
              _selectedOperator != null &&
              Validator.amountValidator(_amountController.text) == null;
    });
  }

  void _processRecharge() async {
    if (mounted) {
      final homeCubit = context.read<RechargeCubit>();
      if (Utils.checkNumberPrefix(_phoneController.text) == MNO.nt) {
        await homeCubit.rechargeNamaste(
            int.parse(_amountController.text), _phoneController.text);
      } else if (_selectedOperator == MNO.ncell) {
        await homeCubit.rechargeNcell(
            int.parse(_amountController.text), _phoneController.text);
      }
    } else {
      if (mounted) {
        final homeCubit = context.read<RechargeCubit>();
        if (Utils.checkNumberPrefix(_phoneController.text) == MNO.nt) {
          await homeCubit.rechargeNamaste(
              int.parse(_amountController.text), _phoneController.text);
        } else if (_selectedOperator == MNO.ncell) {
          await homeCubit.rechargeNcell(
              int.parse(_amountController.text), _phoneController.text);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mobile Topup",
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
                  if (value.length == 10) {
                    setState(() {
                      _selectedOperator = Utils.checkNumberPrefix(value);
                    });
                  }
                  _formKey.currentState?.validate();
                },
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              _selectedOperator == null && _phoneController.text.length < 10
                  ? const SizedBox()
                  : ChoiceChip(
                      label: Text(
                        _selectedOperator!,
                        style:  TextStyle(
                            color: _selectedOperator == MNO.nt
                                ? AppColors.buttonColor
                                : Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      selected: true,
                      selectedColor: Colors.white,
                    ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
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
              BlocConsumer<RechargeCubit, RechargeState>(
                listener: (context, state) {
                  if (state is RechargeSelected) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.rechargeComplete,
                      (_) => false,
                    );
                  } else if (state is RechargeError) {
                    showErrorDialog(context, "Error Occured", state.message);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.rechargeComplete,
                      (_) => false,
                    );
                  } else if (state is Recharging) {
                    showLoadingDialog(context);
                  }
                },
                builder: (BuildContext context, RechargeState state) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isFormValid) {
                          if (int.parse(_amountController.text) > 0) {
                            _processRecharge();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Enter Valid Amount"),
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
          ),
        ),
      ),
    );
  }
}
