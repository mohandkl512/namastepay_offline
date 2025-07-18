import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils/custom_toast.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/tv_data.dart';
import 'package:ussd_npay/viewmodels/states/tv_state.dart';
import 'package:ussd_npay/viewmodels/tv_cubit.dart';
import 'package:ussd_npay/widgets/service_page.dart';
import 'package:ussd_npay/widgets/tv_dropdown.dart';

class TvPaymentPage extends StatefulWidget {
  const TvPaymentPage({super.key});

  @override
  State<TvPaymentPage> createState() => _TvPaymentPageState();
}

class _TvPaymentPageState extends State<TvPaymentPage> {
  String? selectedTv;
  String? selectedOption;
  bool _isFormValid = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();
  void _validateForm() {
    setState(() {
      _isFormValid = _controller.text.isNotEmpty;
    });
  }

  void _processRequest() async {
    final tvCubit = context.read<TvCubit>();

    await tvCubit.makePayment(
      _controller.text,
      selectedTv!,
      selectedOption!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ServicePage(
      title: 'TV Recharge',
      body: ServiceForm<TvCubit, TvState>(
        formKey: _formKey,
        children: [
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Select a TV'),
          ),
          CustomDropDown(
            onChanged: (value) {
              dPrint('On TV Selected: $value');
              setState(() {
                selectedTv = value;
              });
            },
            items: TvData.tvs,
            selectedValue: selectedTv,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Select Payment Option'),
          ),
          CustomDropDown(
            onChanged: (value) {
              setState(() {
                selectedOption = value;
              });
            },
            items: TvData.tvs[selectedTv] == TvData.dishTv
                ? TvData.dishTVPaymentOptions
                : TvData.simTvPaymentOption,
            selectedValue: selectedOption,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NumberFormField(
              controller: _controller,
              labelText: 'Customer ID',
              onChanged: (value) {
                _validateForm();
              },
            ),
          ),
          ServiceFormSubmitButton(
            formKey: _formKey,
            onValid: () {
              if (selectedOption != null &&
                  selectedTv != null &&
                  _isFormValid) {
                dPrint('Option and TV not Null');
                _processRequest();
              } else {
                showCustomToast(context, 'Select Options and Proceed');
              }
            },
          ),
        ],
      ),
    );
  }
}
