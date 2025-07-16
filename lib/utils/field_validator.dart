class Validator {
  static String? _generalPhoneNumberValidator(
      String? phoneNumber, int requiredLength) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number is required';
    } else if (phoneNumber.length != requiredLength) {
      return 'Phone number must be $requiredLength digits';
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
      return 'Phone number can only contain digits';
    }
    return null;
  }

  static String? cellPhoneNumberValidator(String? phoneNumber) {
    final phoneNumberRegex =
        RegExp(r'^(984|985|986|976|974|975|980|981|982|970)\d{7}$');
    return _generalPhoneNumberValidator(phoneNumber, 10) ??
        (!phoneNumberRegex.hasMatch(phoneNumber!)
            ? 'Invalid phone number'
            : null);
  }

  static String? landlineNumberValidator(String? phoneNumber) {
    final phoneNumberRegex = RegExp(r'^0\d{8}$');
    return _generalPhoneNumberValidator(phoneNumber, 9) ??
        (!phoneNumberRegex.hasMatch(phoneNumber!)
            ? 'Phone number must startn with 0'
            : null);
  }

  static String? amountValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    // Try to parse the value to a number
    final amount = int.tryParse(value);

    if (amount == null) {
      return 'Invalid amount';
    }

    // Additional checks, e.g., if the amount should be positive
    if (amount <= 0) {
      return 'Amount should be greater than zero';
    }
    return null;
  }

  static String? pinValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your PIN';
    }
    if (value.length != 4) {
      return 'PIN must be 4 digits';
    }
    return null;
  }

  // agent cash out amount greater or equal to 100
  static String? cashOutAmountValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    // Try to parse the value to a number
    final amount = double.tryParse(value);

    if (amount == null) {
      return 'Invalid amount';
    }

    // Additional checks, e.g., if the amount should be positive
    if (amount <= 99) {
      return 'Minimum Amount is Rs 100';
    }
    return null;
  }

  // validate pin
  static String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pin is required';
    } else if (value.length < 4) {
      return 'Pin must be 4 digits';
    } else if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
      return 'Pin can only contain digits';
    }
    return null;
  }
}
