import 'package:flutter/material.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:bloc/bloc.dart';
import 'package:ussd_npay/viewmodels/states/service_state.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'success_router.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key, this.title, this.body});

  final String? title;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(
              title: Text(
                title!,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
      body: body,
    );
  }
}

class ServiceForm<B extends Cubit<S>, S extends ServiceBaseState>
    extends StatelessWidget {
  const ServiceForm({
    super.key,
    this.formKey,
    this.children = const <Widget>[],
  });

  final Key? formKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: SuccessRouter<B, S>(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

class ServiceFormSubmitButton extends StatelessWidget {
  const ServiceFormSubmitButton({
    super.key,
    required this.formKey,
    this.text = 'Proceed',
    this.onValid = _dummy,
    this.onInvalid = _dummy,
  });

  static void _dummy() {}

  final GlobalKey<FormState> formKey;
  final String text;
  final VoidCallback onValid;
  final VoidCallback onInvalid;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            onValid();
          } else {
            onInvalid();
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.buttonColor,
        ),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class NepaliRupeeIcon extends StatelessWidget {
  const NepaliRupeeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        '\u0930\u0941',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class NumberFormField extends StatelessWidget {
  const NumberFormField({
    super.key,
    this.controller,
    this.labelText,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
  });

  // TODO: remove magic numbers
  NumberFormField.amount({
    super.key,
    int minimum = 0,
    this.controller,
    this.labelText,
    this.maxLength,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.prefixIcon = const NepaliRupeeIcon(),
  }) : validator = Validator.createAmountValidator(minimum);

  // TODO: use correct icons
  const NumberFormField.cellPhone({
    super.key,
    this.controller,
    this.labelText,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.prefixIcon = const Icon(Icons.phone),
    this.validator = Validator.cellPhoneNumberValidator,
  }) : maxLength = 10;

  const NumberFormField.landline({
    super.key,
    this.controller,
    this.labelText,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.prefixIcon = const Icon(Icons.phone),
    this.validator = Validator.landlineNumberValidator,
  }) : maxLength = 9;

  const NumberFormField.pin({
    super.key,
    this.controller,
    this.labelText,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = true,
    this.maxLength = 4,
    this.validator = Validator.pinValidator,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? labelText;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: validator,
      onChanged: onChanged,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
