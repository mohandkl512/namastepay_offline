import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/viewmodels/request_cubit.dart';
import 'package:ussd_npay/viewmodels/states/request_state.dart';
import 'package:ussd_npay/widgets/service_page.dart';

class RequestMoneyScreen extends StatefulWidget {
  const RequestMoneyScreen({super.key});

  @override
  State<RequestMoneyScreen> createState() => _RequestMoneyScreenState();
}

class _RequestMoneyScreenState extends State<RequestMoneyScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _processRequest() async {
    final requestCubit = context.read<RequestCubit>();
    await requestCubit.requestMoney(
        _phoneController.text, int.parse(_amountController.text));
  }

  @override
  Widget build(BuildContext context) {
    return ServicePage(
      title: 'Request Money',
      body: ServiceForm<RequestCubit, RequestState>(
        formKey: _formKey,
        children: [
          const SizedBox(height: 8),
          NumberFormField.cellPhone(
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
