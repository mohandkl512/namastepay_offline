import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/viewmodels/cashout_cubit.dart';
import 'package:ussd_npay/viewmodels/states/cashout_state.dart';
import 'package:ussd_npay/widgets/service_page.dart';

class CashoutPage extends StatefulWidget {
  const CashoutPage({super.key});

  @override
  State<CashoutPage> createState() => _CashoutPageState();
}

class _CashoutPageState extends State<CashoutPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const int _minAmount = 100;

  void _processCashout() async {
    if (mounted) {
      final cashoutCubit = context.read<CashoutCubit>();
      await cashoutCubit.processCashout(
          _phoneController.text, int.parse(_amountController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ServicePage(
      title: 'Cash Out',
      body: ServiceForm<CashoutCubit, CashoutState>(
        formKey: _formKey,
        children: [
          const SizedBox(height: 8),
          NumberFormField.cellPhone(
            controller: _phoneController,
            labelText: 'Agent Phone Number',
          ),
          const SizedBox(height: 8),
          NumberFormField.amount(
            controller: _amountController,
            labelText: 'Amount: Minimum Rs.$_minAmount',
            minimum: _minAmount,
          ),
          const SizedBox(height: 32),
          ServiceFormSubmitButton(
            formKey: _formKey,
            onValid: _processCashout,
          ),
        ],
      ),
    );
  }
}
