import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/viewmodels/states/send_money_state.dart';
import '../routes/route_path.dart';
import '../viewmodels/send_money_cubit.dart';
import '../widgets/numpad_send_money.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isFormValid = false;
  int amount = 0;

  // List of available network operators
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    dPrint(amount);
    dPrint(_phoneController.text);
    setState(() {
      _isFormValid =
          Validator.validatePhoneNumber(_phoneController.text) == null;
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
    final requestCubit = context.read<SendMoneyCubit>();
    await requestCubit.sendMoney(_phoneController.text, amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Money")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            ),
            const SizedBox(height: 8),
            const NumpadSendMoney(),
            const SizedBox(height: 32),
            BlocConsumer<SendMoneyCubit, SendMoneyState>(
              listener: (context, state) {
                dPrint(state);
                if (state is SentMoney) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.moneySent,
                    (_) => false,
                  );
                } else if (state is SendMoneyError) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.moneySent,
                    (_) => false,
                  );
                } else if (state is SendingMoney) {
                  showLoadingDialog(context);
                }
              },
              builder: (context, state) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      amount = (state is SendMoneyInitial) ? state.amount : 0;
                      if (_isFormValid) {
                        if (amount > 0) {
                          _processRequest();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  "Enter Amount and tick the checkmark"),
                              backgroundColor: Colors.red[400],
                              duration: const Duration(
                                seconds: 3,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor:
                          _isFormValid ? Colors.blue : Colors.grey,
                    ),
                    child: const Text("Send Request"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
