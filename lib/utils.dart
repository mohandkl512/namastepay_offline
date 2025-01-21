import 'package:flutter_sim_data/sim_data.dart';
import 'package:flutter_sim_data/sim_data_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/operators.dart';

class Utils {
  static bool isPinValid(String pin) {
    return pin.length >= 4 && RegExp(r'^\d+$').hasMatch(pin);
  }

  static String removePrefix(String input) {
    if (input.startsWith('+977')) {
      // Remove the '+977' prefix
      return input.replaceFirst('+977', '');
    } else if (input.startsWith('977')) {
      // Remove the '977' prefix
      return input.replaceFirst('977', '');
    }
    String result = input.replaceAll(RegExp(r'\s+|-'), '');
    // Return the input string as is if no prefix exists
    return result;
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    final response = Validator.validatePhoneNumber(removePrefix(phoneNumber));
    if (response == null) {
      dPrint("valid phone number");
      return true;
    } else {
      dPrint("Validation Error: $response");
    }
    return false;
  }

  static bool isvalidFtth(String? number) {
    if (number != null && number.length > 8) {
      dPrint("valid phone number");
      return true;
    } else {
      dPrint("Validation Error: FTTH");
    }
    return false;
  }

  static Future<int> getSubscriptionId(String phoneNumber) async {
    // bool permissionsGranted = await requestPermissions();
    // int subscriptionId = SubscriptionID.auto;
    // if (permissionsGranted) {
    //   dPrint("permission granted for phone: $phoneNumber");
    //   final simData = await SimData().getSimData();
    //   for (var sim in simData) {
    //     if (removePrefix(sim.phoneNumber) == phoneNumber) {
    //       subscriptionId = sim.subscriptionId;
    //     }
    //   }
    // }
    return -1;
  }

  static Future<List<SimDataModel>> getNumbers() async {
    bool permissionsGranted = await requestPermissions();
    if (permissionsGranted) {
      final simData = await SimData().getSimData();
      // for (var sim in simData) {
      //   if (removePrefix(sim.phoneNumber) == phoneNumber) {
      //     subscriptionId = sim.subscriptionId;
      //   }
      // }
      return simData;
    }
    return <SimDataModel>[];
  }

  static Future<bool> requestPermissions() async {
    var permissions = await [Permission.phone].request();
    // Check if both permissions are granted
    bool granted = permissions[Permission.phone]!.isGranted;
    return granted;
  }

  static String checkNumberPrefix(String numberString) {
    // Convert the number to a string to check the prefix

    // Check the conditions for each prefix
    if (numberString.startsWith('984') ||
        numberString.startsWith('985') ||
        numberString.startsWith('986') ||
        numberString.startsWith('976') ||
        numberString.startsWith('974') ||
        numberString.startsWith('975')) {
      return MNO.nt;
    } else if (numberString.startsWith('980') ||
        numberString.startsWith('981') ||
        numberString.startsWith('982') ||
        numberString.startsWith('970')) {
      return MNO.ncell;
    } else {
      return MNO
          .invalid; // Return 0 if the number doesn't match any of the conditions
    }
  }

  static bool isValidLandline(String number) {
    // Map of area codes in Nepal
    Map<String, String> areaCodes = {
      "097": "Achham, Bajura",
      "077": "Agrghakanchi",
      "068": "Baglung",
      "095": "Baitadi",
      "092": "Bajhang",
      "081": "Banke",
      "053": "Bara",
      "084": "Bardiya",
      "029": "Bhojpur",
      "056": "Chitwan",
      "096": "Dadeldhura",
      "089": "Dailekh,Jajarkot",
      "082": "Dang",
      "093": "Darchula",
      "010": "Dhading",
      "026": "Dhankuta",
      "041": "Dhanusa",
      "049": "Dolakha",
      "094": "Doti",
      "064": "Gorkha",
      "079": "Gulmi",
      "019": "Humla",
      "027": "Illam",
      "023": "Jhapa",
      "087": "Jumla,Kalikot,Dolpa",
      "091": "Kailali",
      "099": "Kanchanpur",
      "076": "Kapilbastu",
      "061": "Kaski",
      "01": "Kathmandu,Lalitpur,Bhaktapur",
      "011": "Kavrepalanchowk",
      "036": "Khotang",
      "066": "Lamjung",
      "057": "Makwanpur",
      "044": "Mohottari",
      "021": "Morang",
      "069": "Mustang",
      "078": "Nawalparasi",
      "037": "Okhaldhunga",
      "075": "Palpa",
      "024": "Panchthar",
      "067": "Parbat",
      "051": "Parsa",
      "086": "Pyuthan",
      "048": "Ramechha",
      "055": "Rautahat",
      "088": "Rukum",
      "071": "Rupandehi",
      "031": "Saptari",
      "046": "Sarlahi",
      "047": "Sindhuli",
      "033": "Siraha",
      "038": "Solukhumbu",
      "025": "Sunsari",
      "083": "Surkhet",
      "063": "Syangja",
      "065": "Tanahun",
      "035": "Udayapur",
    };

    // Ensure the number is exactly 9 digits
    if (number.length != 9) return false;

    // Check if the number starts with any valid area code
    for (String code in areaCodes.keys) {
      if (number.startsWith(code)) {
        return true;
      }
    }

    return false; // Number does not match any area code
  }
}
