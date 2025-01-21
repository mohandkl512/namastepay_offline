import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/utils/isp_data.dart';
import 'package:ussd_npay/utils/namaste_pay_icons.dart';
import 'package:ussd_npay/viewmodels/payments_cubit.dart';
import 'package:ussd_npay/viewmodels/states/payment_state.dart';
import '../../routes/route_path.dart';
import '../../utils/error_dialog.dart';
import '../../utils/field_validator.dart';
import '../../utils/loading_dialog.dart';
import '../../utils/npay_texts.dart';

class NtadslPayment extends StatefulWidget {
  final String title;
  const NtadslPayment({super.key, required this.title});

  @override
  State<NtadslPayment> createState() => _NtadslPaymentState();
}

class _NtadslPaymentState extends State<NtadslPayment> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _landlineError;
  String? _amountError;
  bool validated = false;
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {
        _landlineError = Utils.isValidLandline(_phoneController.text)
            ? null
            : "Not a valid landline number";
      });
      validateBoth();
    });
    _amountController.addListener(() {
      setState(() {
        _amountError = Validator.amountValidator(_amountController.text) == null
            ? null
            : "Enter a valid amount";
      });
      validateBoth();
    });
  }

  validateBoth() {
    if (Validator.amountValidator(_amountController.text) == null &&
        Utils.isValidLandline(_phoneController.text)) {
      setState(() {
        validated = true;
      });
    } else {
      validated = false;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 10.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
              color: AppColors.appBarBackGroundColor,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Image.asset(
                NamastePayIcons.ntc,
                width: 12.w,
                height: 12.w,
              ),
              SizedBox(width: 10.w),
              Text(
                "NT ADSL",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
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
                  maxLength: 9,
                  validator: (String? message) =>
                      Utils.isValidLandline(_phoneController.text)
                          ? null
                          : "Invalid Input",
                  decoration: InputDecoration(
                    labelText: "Landline Number",
                    errorText: _landlineError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    errorText: _amountError,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ), // Add padding to ensure proper spacing
                      child: Text(
                        NpayTexts.rs, // Currency symbol or any other text
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validator.amountValidator,
                ),
                const SizedBox(height: 32),
                BlocConsumer<PaymentsCubit, PaymentState>(
                  listener: (context, state) {
                    if (state is PaymentDone) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesName.ispPaymentSucess,
                        (_) => false,
                      );
                    } else if (state is PaymentError) {
                      showErrorDialog(context, "Error Occured", state.message);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesName.ispPaymentSucess,
                        (_) => false,
                      );
                    } else if (state is PaymentProcessing) {
                      showLoadingDialog(context);
                    }
                  },
                  builder: (BuildContext context, PaymentState state) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if(kReleaseMode){
                          if (validated) {
                            final paymentsCubit = context.read<PaymentsCubit>();
                            paymentsCubit.makePaymentUAT(_phoneController.text,
                                IspData.ntadsl, _amountController.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Validation Error"),
                                backgroundColor: Colors.red[400],
                                duration: const Duration(
                                  seconds: 3,
                                ),
                              ),
                            );
                          }

                          }else{
                             ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Only Available on Live"),
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
                          backgroundColor: validated
                              ? AppColors.buttonColor
                              : AppColors.lightGreyColor,
                        ),
                        child: Text(
                          "Pay",
                          style: validated
                              ? Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.white)
                              : Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.black.withAlpha(80)),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
