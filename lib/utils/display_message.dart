class DisplayMessage {
  static const String authenticated = "Your pin is sucessfully verified";

  //"Provided Pin Authentication is missing or invalid. Remaining Attempt:3";
  static const String invalidPinFirstAttempt =
      "Provided Pin Authentication is missing or invalid. Remaining Attempt:3";
  //"Provided Pin Authentication is missing or invalid. Remaining Attempt:2";
  static const String invalidPinSecondAttempt =
      "Provided Pin Authentication is missing or invalid. Remaining Attempt:2";
  //"Provided Pin Authentication is missing or invalid. Remaining Attempt:1";
  static const String invalidPinThirdAttempt =
      "Provided Pin Authentication is missing or invalid. Remaining Attempt:1";
  // User has been temporarily blocked due to invalid credentials
  static const String invalidPinFinalAttempt =
      "User has been temporarily blocked due to invalid credentials ";
  //
  static const String servicesCurrentlyNotAvailable =
      "Services are currently unavailable";
  static const String unexpectedError = "Some unexpected error occured";
  static const String registrationFlowActive =
      "Your contact number might not have been registered in Namastepay wallet.";
  static const String timeoutException =
      "It took too long to respond, try again later";
}
