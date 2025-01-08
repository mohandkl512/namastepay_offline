import 'package:flutter_sim_data/sim_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/subscription_id.dart';

class Utils {
  static bool isPinValid(String pin) {
    if (Validator.amountValidator(pin) == null) {
      return true;
    }
    return false;
    // return pin.length >= 4 && RegExp(r'^\d+$').hasMatch(pin);
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    final response = Validator.validatePhoneNumber(phoneNumber);
    if (response == null) {
      return true;
    } else {
      dPrint("Validation Error: $response");
    }
    return false;
  }

  static Future<int> getSubscriptionId(String phoneNumber) async {
    bool permissionsGranted = await requestPermissions();
    int subscriptionId = SubscriptionID.auto;
    if (permissionsGranted) {
      final simData = await SimData().getSimData();
      for (var sim in simData) {
        if (sim.phoneNumber == phoneNumber) {
          subscriptionId = sim.subscriptionId;
        }
      }
    }
    return subscriptionId;
  }

  static Future<bool> requestPermissions() async {
    var permissions = await [Permission.phone].request();
    // Check if both permissions are granted
    bool granted = permissions[Permission.phone]!.isGranted;
    return granted;
  }
}
