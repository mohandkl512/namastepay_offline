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
import 'package:ussd_npay/widgets/service_page.dart';

class NtftthPayment extends StatefulWidget {
  final String title;
  const NtftthPayment({super.key, required this.title});

  @override
  State<NtftthPayment> createState() => _NtftthPaymentState();
}

class _NtftthPaymentState extends State<NtftthPayment> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _doPayment() {
    if (kReleaseMode) {
      final paymentsCubit = context.read<PaymentsCubit>();
      paymentsCubit.makePayment(
          _phoneController.text, IspData.ntffth, _amountController.text);
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
        ServiceForm<PaymentsCubit, PaymentState>(
          formKey: _formKey,
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
            ServiceFormSubmitButton(
              formKey: _formKey,
              onValid: _doPayment,
            ),
          ],
        ),
      ],
    );
  }
}
