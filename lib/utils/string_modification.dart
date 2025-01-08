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