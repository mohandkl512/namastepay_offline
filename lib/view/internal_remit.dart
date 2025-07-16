import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/viewmodels/internal_remit_cubit.dart';
import 'package:ussd_npay/viewmodels/states/internal_remit_state.dart';
import 'package:ussd_npay/widgets/service_page.dart';

class InternalRemit extends StatefulWidget {
  const InternalRemit({super.key});

  @override
  State<InternalRemit> createState() => _InternalRemitState();
}

class _InternalRemitState extends State<InternalRemit> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const int _minAmount = 100;

  void _processRemit() async {
    if (int.parse(_amountController.text) >= _minAmount) {
      if (mounted) {
        final cashoutCubit = context.read<InternalRemitCubit>();
        await cashoutCubit.processInternalRemit(
          _phoneController.text,
          int.parse(_amountController.text),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter amount more than Rs.$_minAmount'),
          backgroundColor: Colors.red[400],
          duration: const Duration(
            seconds: 3,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ServicePage(
      title: 'Internal Remit',
      body: ServiceForm<InternalRemitCubit, RemitState>(
        formKey: _formKey,
        children: [
          const SizedBox(height: 8),
          NumberFormField.cellPhone(
            controller: _phoneController,
            labelText: 'Receiver Phone Number (Unregistered)',
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
            onValid: _processRemit,
          ),
        ],
      ),
    );
  }
}
