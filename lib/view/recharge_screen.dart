import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/utils/operators.dart';
import 'package:ussd_npay/viewmodels/recharge_cubit.dart';
import 'package:ussd_npay/viewmodels/states/recharge_state.dart';
import 'package:ussd_npay/widgets/service_page.dart';

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

  // List of available network operators
  final List<String> operators = [MNO.nt, MNO.ncell];

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
    }
  }

  Widget _showOperator() {
    if (_selectedOperator == null || _phoneController.text.length < 10) {
      return const SizedBox();
    } else {
      return ChoiceChip(
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ServicePage(
      title: 'Mobile Topup',
      body: ServiceForm<RechargeCubit, RechargeState>(
        formKey: _formKey,
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
            },
          ),
          _showOperator(),
          const SizedBox(height: 8),
          NumberFormField.amount(
            controller: _amountController,
            labelText: 'Amount',
          ),
          const SizedBox(height: 32),
          ServiceFormSubmitButton(
            text: 'Recharge',
            formKey: _formKey,
            onValid: _processRecharge,
          ),
        ],
      ),
    );
  }
}
