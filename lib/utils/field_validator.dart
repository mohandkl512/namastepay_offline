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

  static String? Function(String? value) createAmountValidator(int minimum) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Amount is required';
      }

      final amount = int.tryParse(value);

      if (amount == null) {
        return 'Invalid amount';
      }

      if (amount <= 0) {
        return 'Amount must be greater than 0';
      } else if (amount < minimum) {
        return 'Amount cannot be less than $minimum';
      }
      return null;
    };
  }

  static String? pinValidator(String? value) {
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
