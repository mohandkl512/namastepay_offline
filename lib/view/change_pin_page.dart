import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/viewmodels/profile_cubit.dart';
import 'package:ussd_npay/viewmodels/states/profile_state.dart';
import '../routes/route_path.dart';
import '../utils/custom_toast.dart';
import '../utils/loading_dialog.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  _ChangePinPageState createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  String _errorMessage = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_newPinController.text == _confirmPinController.text) {
        context.read<ProfileCubit>().changePin(_newPinController.text);
      } else {
        setState(() {
          _errorMessage = 'PINs do not match!';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _newPinController,
                obscureText: _obscureText,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a PIN';
                  }
                  if (value.length != 4) {
                    return 'PIN must be 4 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _confirmPinController,
                obscureText: _obscureText,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your PIN';
                  }
                  if (value.length != 4) {
                    return 'PIN must be 4 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 1.h),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                ),
              SizedBox(height: 1.h),
              BlocListener<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileLoading) {
                    showLoadingDialog(context);
                  } else if (state is ProfileError) {
                    Navigator.pop(context);
                    showCustomToast(context, "Error Occured Changing Pin");
                  } else if (state is ProfileLoaded) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RoutesName.login, (_) => false);
                  }
                },
                child: ElevatedButton(
                  onPressed: () => _submitForm(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: AppColors.buttonColor,
                  ),
                  child: Text(
                    "Proceed",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
