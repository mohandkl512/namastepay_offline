import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/viewmodels/profile_cubit.dart';
import 'package:ussd_npay/viewmodels/states/profile_state.dart';
import 'package:ussd_npay/widgets/service_page.dart';

import '../routes/route_path.dart';
import '../utils/custom_toast.dart';
import '../utils/loading_dialog.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void _submitForm() {
    if (_newPinController.text == _confirmPinController.text) {
      context.read<ProfileCubit>().changePin(_newPinController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('PINs do not match'),
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
    return ServicePage(
      title: 'Change PIN',
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NumberFormField.pin(
              controller: _newPinController,
              obscureText: _obscureText,
              labelText: 'New PIN',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            SizedBox(height: 1.h),
            NumberFormField.pin(
              controller: _confirmPinController,
              obscureText: _obscureText,
              labelText: 'Confirm PIN',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            SizedBox(height: 1.h),
            BlocListener<ProfileCubit, ProfileState>(
              listener: (context, state) {
                switch (state) {
                  case ProfileLoaded _:
                    Navigator.pushNamedAndRemoveUntil(
                        context, RoutesName.login, (_) => false);
                  case ProfileError _:
                    Navigator.pop(context);
                    showCustomToast(context, 'Error Occured Changing Pin');
                  case ProfileLoading _:
                    showLoadingDialog(context);
                }
              },
              child: ServiceFormSubmitButton(
                formKey: _formKey,
                onValid: _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
