import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/viewmodels/verification_cubit.dart';
import 'package:ussd_npay/viewmodels/states/verification_state.dart';
import 'home_page.dart';

class VerificationPage extends StatelessWidget {
  VerificationPage({super.key});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
// Inject dependency

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Form'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Pin'),
              ),
              const SizedBox(height: 16),
              BlocConsumer<VerificationCubit, VerificationState>(
                listener: (context, state) {
                  if (state is VerificationError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red[400],
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    });
                  } else if (state is Verified) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                },
                builder: (BuildContext context, VerificationState state) {
                  return ElevatedButton(
                    onPressed: () async {
                      final phone = phoneController.text;
                      final password = passwordController.text;
                  
                    },
                    child: const Text('Submit'),
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
