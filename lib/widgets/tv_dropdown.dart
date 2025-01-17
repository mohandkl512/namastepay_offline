import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final Function(String?)? onChanged;
  final Map<String, String> items;
  final String? selectedValue;
  const CustomDropDown({
    super.key,
    required this.onChanged,
    required this.items,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButton<String>(
              value: selectedValue,
              hint: const Text('Select an Option'),
              isExpanded: true,
              underline: const SizedBox(), 
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.black),
              onChanged: onChanged,
              items: items.keys.map<DropdownMenuItem<String>>((String key) {
                return DropdownMenuItem<String>(
                  value: key, 
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                        items[key] ?? ""), // Display the key in the dropdown
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
