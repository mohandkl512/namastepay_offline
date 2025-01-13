import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/viewmodels/landline_cubit.dart';
import 'package:ussd_npay/viewmodels/states/landline_recharge_state.dart';
import 'package:ussd_npay/widgets/numpad_landline_recharge.dart';
import '../routes/route_path.dart';

class LandlineRechargePage extends StatefulWidget {
  const LandlineRechargePage({super.key});

  @override
  _LandlineRechargePageState createState() => _LandlineRechargePageState();
}

class _LandlineRechargePageState extends State<LandlineRechargePage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isFormValid = false;
  int amount = 0;
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    dPrint(amount);
    dPrint(_phoneController.text);
    setState(() {
      _isFormValid = Utils.isValidLandline(_phoneController.text);
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
    final requestCubit = context.read<LandlineCubit>();
    await requestCubit.payBill( amount, _phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Landline Recharge")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 9,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const NumpadForLandline(),
            const SizedBox(height: 32),
            BlocConsumer<LandlineCubit, LandlineRechargeState>(
              listener: (context, state) {
                if (state is LandlineRechargeSelected) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.landlineSucess,
                    (_) => false,
                  );
                } else if (state is LandlineError) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.landlineSucess,
                    (_) => false,
                  );
                } else if (state is LandlineRecharging) {
                  showLoadingDialog(context);
                }
              },
              builder: (context, state) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      amount =
                          (state is LandlineRechargeInitial) ? state.amount : 0;
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text("Landline number incorrect format"),
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
                      backgroundColor: _isFormValid ? Colors.blue : Colors.grey,
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
