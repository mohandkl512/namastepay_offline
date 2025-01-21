import 'package:flutter/material.dart';
import 'package:flutter_sim_data/sim_data_model.dart';

class PhoneDropdown extends StatelessWidget {
  final Function(SimDataModel?)? onChanged;
  final List<SimDataModel> items;
  final SimDataModel? selectedValue;
  const PhoneDropdown({
    super.key,
    required this.onChanged,
    required this.items,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DropdownButton<SimDataModel>(
          value: selectedValue,
          hint: const Text('Select a SIM'),
          isExpanded: true,
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(color: Colors.black),
          onChanged: onChanged,
          items: items.map((simDataModel) {
            return DropdownMenuItem(
              value: simDataModel,
              child: simDataModel.phoneNumber.isEmpty
                  ? Text("Sim: ${simDataModel.simSlotIndex + 1}")
                  : Text(simDataModel.phoneNumber),
            );
          }).toList(),
        ),
      ),
    );
  }
}
