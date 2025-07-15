import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils/custom_toast.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/utils/tv_data.dart';
import 'package:ussd_npay/viewmodels/states/tv_state.dart';
import 'package:ussd_npay/viewmodels/tv_cubit.dart';
import 'package:ussd_npay/widgets/form_page.dart';
import 'package:ussd_npay/widgets/tv_dropdown.dart';
import '../routes/route_path.dart';
import '../utils/app_colors.dart';

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
    return FormPage(
      title: 'TV Recharge',
      formKey: _formKey,
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Select a TV"),
        ),
        CustomDropDown(
          onChanged: (value) {
            dPrint("On TV Selected: $value");
            setState(() {
              selectedTv = value;
            });
          },
          items: TvData.tvs,
          selectedValue: selectedTv,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Select Payment Option"),
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
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Customer ID',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              _validateForm();
            },
          ),
        ),
        BlocListener<TvCubit, TvState>(
          listener: (context, state) {
            dPrint(state);
            switch (state) {
              case TvRequestSucessfull _:
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.tvSuccess,
                  (_) => false,
                );
              case TvRequestError _:
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.tvSuccess,
                  (_) => false,
                );
              case TvRequestLoading _:
                showLoadingDialog(context);
            }
          },
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                if (selectedOption != null &&
                    selectedTv != null &&
                    _isFormValid) {
                  dPrint("Option and TV not Null");
                  _processRequest();
                } else {
                  showCustomToast(context, "Select Options and Proceed");
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
                "Make Payment",
                style: _isFormValid
                    ? Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.white)
                    : Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        )
      ],
    );
  }
}
