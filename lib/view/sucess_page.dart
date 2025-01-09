import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/viewmodels/home_cubit.dart';
import 'package:ussd_npay/viewmodels/states/home_state.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Success")),
      body: Center(
        child: BlocBuilder<HomeCubit, ServiceState>(
          builder: (context, state) {
            final service = state as ServiceSelected;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 100),
                const SizedBox(height: 16),
                const Text("Action Successful!",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(service.serviceCode ?? "",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text("Proceed Forward"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
