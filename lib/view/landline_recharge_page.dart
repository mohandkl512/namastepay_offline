import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/viewmodels/landline_cubit.dart';
import 'package:ussd_npay/viewmodels/states/landline_recharge_state.dart';
import 'package:ussd_npay/widgets/service_page.dart';

class LandlineRechargePage extends StatefulWidget {
  const LandlineRechargePage({super.key});

  @override
  State<LandlineRechargePage> createState() => _LandlineRechargePageState();
}

class _LandlineRechargePageState extends State<LandlineRechargePage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _processRequest() async {
    final requestCubit = context.read<LandlineCubit>();
    await requestCubit.payBill(
        int.parse(_amountController.text), _phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    return ServicePage(
      title: 'Landline Recharge',
      body: ServiceForm<LandlineCubit, LandlineRechargeState>(
        formKey: _formKey,
        children: [
          const SizedBox(height: 8),
          NumberFormField.landline(
            controller: _phoneController,
            labelText: 'Phone Number',
          ),
          const SizedBox(height: 8),
          NumberFormField.amount(
            controller: _amountController,
            labelText: 'Amount',
          ),
          const SizedBox(height: 32),
          ServiceFormSubmitButton(
            formKey: _formKey,
            onValid: _processRequest,
          ),
        ],
      ),
    );
  }
}
