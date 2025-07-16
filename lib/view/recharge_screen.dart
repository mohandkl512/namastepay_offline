import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/operators.dart';
import 'package:ussd_npay/viewmodels/recharge_cubit.dart';
import 'package:ussd_npay/viewmodels/states/recharge_state.dart';
import 'package:ussd_npay/widgets/success_router.dart';
import 'package:ussd_npay/widgets/form_page.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
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
          Validator.cellPhoneNumberValidator(_phoneController.text) == null &&
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
              NumberFormField.cellPhone(
                controller: _phoneController,
                labelText: 'Phone Number',
                onChanged: (value) {
                  if (value.length == 10) {
                    setState(() {
                      _selectedOperator = Utils.checkNumberPrefix(value);
                    });
                  }
                  _formKey.currentState?.validate();
                },
              ),
              _selectedOperator == null && _phoneController.text.length < 10
                  ? const SizedBox()
                  : ChoiceChip(
                      label: Text(
                        _selectedOperator!,
                        style: TextStyle(
                            color: _selectedOperator == MNO.nt
                                ? AppColors.buttonColor
                                : Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      selected: true,
                      selectedColor: Colors.white,
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
              SuccessRouter<RechargeCubit, RechargeState>(
                child: Center(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
