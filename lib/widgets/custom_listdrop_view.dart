import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String hintText;
  final TextStyle hintStyle;
  final EdgeInsets contentPadding;
  final InputDecoration borderDecoration;
  final Color fillColor;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? initialValue;

  const CustomDropdownFormField({
    super.key,
    required this.hintText,
    required this.hintStyle,
    required this.contentPadding,
    required this.borderDecoration,
    required this.fillColor,
    required this.items,
    required this.onChanged,
    this.initialValue,
  
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: initialValue,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        contentPadding: contentPadding,
        border: borderDecoration.border,
        filled: true,
        fillColor: fillColor,
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
