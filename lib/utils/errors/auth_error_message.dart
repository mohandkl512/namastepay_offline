import 'package:ussd_npay/utils/error_message.dart';

class AuthErrorMessage extends ErrorMessage {
  //TODO: Warning Please do not remove the message commented at the top of variable as this is the only way we can verify the ussd message

  static const String userNotRegistered =
      "You need to be a registered user to access this offline namastepay feature. ";

  //"Provided Pin Authentication is missing or invalid. Remaining Attempt:3";
  static const String invalidPinFirstAttempt = "Remaining Attempt:3";
  //"Provided Pin Authentication is missing or invalid. Remaining Attempt:2";
  static const String invalidPinSecondAttempt = " Remaining Attempt:2";
  //"Provided Pin Authentication is missing or invalid. Remaining Attempt:1";
  static const String invalidPinThirdAttempt = "Remaining Attempt:1";
  // User has been temporarily blocked due to invalid credentials
  static const String invalidPinFinalAttempt = "blocked ";
  static const String servicesCurrentlyNotAvailable =
      "Services are currently unavailable";
  static const String registrationFlowActive = "Invalid Option Selected";
}
