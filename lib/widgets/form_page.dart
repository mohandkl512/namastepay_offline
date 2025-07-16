import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ussd_npay/utils/field_validator.dart';

class FormPage extends StatelessWidget {
  const FormPage({
    super.key,
    this.formKey,
    this.title = '',
    this.children = const <Widget>[],
  });

  final String title;
  final Key? formKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
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
  const NumberFormField.amount({
    super.key,
    this.controller,
    this.labelText,
    this.maxLength,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.validator = Validator.amountValidator,
    this.prefixIcon = const NepaliRupeeIcon(),
  });

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
