import 'package:flutter/material.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/viewmodels/states/service_state.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key, required this.state});

  final ServiceBaseState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            state is ServiceSuccessState
                ? const Icon(Icons.check_circle, color: Colors.green, size: 100)
                : const Icon(Icons.warning, color: Colors.red, size: 100),
            const SizedBox(height: 8),
            Text(
              state is ServiceErrorState
                  ? 'Action Halted!'
                  : 'Action Successful!',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state is ServiceErrorState
                    ? (state as ServiceErrorState).message
                    : state is ServiceSuccessState
                        ? '${(state as ServiceSuccessState).response}'
                        : 'Unknown State',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, RoutesName.home),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}
