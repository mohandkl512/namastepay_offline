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
import 'package:ussd_npay/widgets/form_page.dart';
import 'package:ussd_npay/widgets/success_router.dart';

class NtftthPayment extends StatefulWidget {
  final String title;
  const NtftthPayment({super.key, required this.title});

  @override
  State<NtftthPayment> createState() => _NtftthPaymentState();
}

// TODO: do proper validation

class _NtftthPaymentState extends State<NtftthPayment> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool validated = false;

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
                'NT FTTH',
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
                NumberFormField.landline(
                  controller: _phoneController,
                  labelText: 'FTTH Number',
                  validator: (String? message) =>
                      Utils.isvalidFtth(_phoneController.text)
                          ? null
                          : 'Invalid Input',
                ),
                const SizedBox(height: 8),
                NumberFormField.amount(
                  controller: _amountController,
                  labelText: 'Amount',
                ),
                const SizedBox(height: 32),
                SuccessRouter<PaymentsCubit, PaymentState>(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (kReleaseMode) {
                          if (validated) {
                            final paymentsCubit = context.read<PaymentsCubit>();
                            paymentsCubit.makePayment(_phoneController.text,
                                IspData.ntffth, _amountController.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Validation Error'),
                                backgroundColor: Colors.red[400],
                                duration: const Duration(
                                  seconds: 3,
                                ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Only Available on Live'),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: validated
                            ? AppColors.buttonColor
                            : AppColors.lightGreyColor,
                      ),
                      child: Text(
                        'Pay',
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
