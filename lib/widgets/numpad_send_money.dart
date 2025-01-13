import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/viewmodels/send_money_cubit.dart';

class NumpadSendMoney extends StatefulWidget {
  const NumpadSendMoney({super.key});

  @override
  _CustomNumberPadState createState() => _CustomNumberPadState();
}

class _CustomNumberPadState extends State<NumpadSendMoney> {
  String input = ""; // To store the entered input as string

  // Method to handle number button press
  void _onNumberPress(String number) {
    setState(() {
      if (input.length < 9) {
        input += number;
      }
    });
    context.read<SendMoneyCubit>().updateAmount(int.parse(input));
  }

  // Method to handle delete button
  void _onDeletePress() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1); // Remove last digit
      }
    });
  }

  // Number Button Widget
  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      onPressed: () => _onNumberPress(number),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(), // Circular buttons
        padding: const EdgeInsets.all(16),
      ),
      child: Text(
        number,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 5,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  for (var i = 1; i <= 9; i++) _buildNumberButton('$i'),
                  ElevatedButton(
                    // Clear Button
                    onPressed: _onDeletePress,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Icon(Icons.backspace, size: 24),
                  ),
                  _buildNumberButton('0'),
                  ElevatedButton(
                    // Submit Button
                    onPressed: () {
                      context
                          .read<SendMoneyCubit>()
                          .updateAmount(int.parse(input));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(Icons.check, size: 24),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                   Text(
                    "रु.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    input.isEmpty ? "" : input,
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
