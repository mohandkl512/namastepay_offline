import 'package:ussd_npay/utils/debug_print.dart';

String findStringUntilNPR(String input) {
  // Convert the input string to lowercase to handle case-insensitivity
  String lowercasedInput = input.toLowerCase();

  // Find the index of "npr" in the string
  int index = lowercasedInput.indexOf('npr');

  // If "npr" is found, return the substring up to that index
  if (index != -1) {
    return input.substring(0, index);
  }

  // If "npr" is not found, return the full string
  return "$input NPR.";
}

String? getAmountOnly(String amountString) {
  String text = amountString;

  // Regular expression to extract the amount
  RegExp regExp = RegExp(r'(\d+\.\d{2})');

  // Find the match
  Match? match = regExp.firstMatch(text);

  if (match != null) {
    // Convert the matched string to a double
    double amount = double.parse(match.group(0)!);

    // Print the amount with 2 decimal precision
    dPrint(amount.toStringAsFixed(2)); // 10481.00
    return amount.toStringAsFixed(2);
  } else {
    dPrint("Amount not found");
    return null;
  }
}
