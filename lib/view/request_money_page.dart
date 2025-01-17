import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/viewmodels/request_cubit.dart';
import 'package:ussd_npay/viewmodels/states/request_state.dart';
import '../routes/route_path.dart';
import '../utils/app_colors.dart';
import '../utils/npay_texts.dart';

class RequestMoneyScreen extends StatefulWidget {
  const RequestMoneyScreen({super.key});

  @override
  _RequestMoneyScreenState createState() => _RequestMoneyScreenState();
}

class _RequestMoneyScreenState extends State<RequestMoneyScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  void _validateForm() {
    setState(() {
      _isFormValid =
          Validator.validatePhoneNumber(_phoneController.text) == null &&
              Validator.amountValidator(_amountController.text) == null;
    });
  }

  // void _showPinDialog() {
  //   TextEditingController pinController = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       title: const Text("Enter PIN"),
  //       content: TextField(
  //         controller: pinController,
  //         keyboardType: TextInputType.number,
  //         obscureText: true,
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Cancel"),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             bool validPin = Utils.isPinValid(pinController.text);
  //             if (validPin) {
  //               Navigator.pop(context);
  //               _processRequest(pinController.text);
  //             } else {
  //               Navigator.pop(context);
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(
  //                   content: const Text("Invalid Pin"),
  //                   backgroundColor: Colors.red[400],
  //                   duration: const Duration(
  //                     seconds: 2,
  //                   ),
  //                 ),
  //               );
  //             }
  //           },
  //           style: ElevatedButton.styleFrom(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //           ),
  //           child: const Text("Proceed"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _processRequest() async {
    final requestCubit = context.read<RequestCubit>();
    await requestCubit.requestMoney(
        _phoneController.text, int.parse(_amountController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Request Money",
        style: Theme.of(context).textTheme.labelLarge,
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _validateForm();
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ), // Add padding to ensure proper spacing
                    child: Text(
                      NpayTexts.rs, // Currency symbol or any other text
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ),
                validator: Validator.amountValidator,
                onChanged: (value) {
                  _validateForm();
                },
              ),
              const SizedBox(height: 32),
              BlocConsumer<RequestCubit, RequestState>(
                listener: (context, state) {
                  if (state is Requested) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.requestCompleted,
                      (_) => false,
                    );
                  } else if (state is RequestError) {
                    // showErrorDialog(context, "Error Occured", state.message);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.requestCompleted,
                      (_) => false,
                    );
                  } else if (state is Requesting) {
                    showLoadingDialog(context);
                  }
                },
                builder: (context, state) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isFormValid) {
                          _processRequest();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  "Either Phone number or amount is invalid"),
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
                        backgroundColor: _isFormValid
                            ? AppColors.buttonColor
                            : AppColors.accentColor,
                      ),
                      child: Text(
                        "Request Money",
                        style: _isFormValid
                            ? Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.white)
                            : Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
