import 'package:ussd_npay/utils/base_ussd_codes.dart';

class UssdMethods {
  /* This method directly checks account balance with provided pin. with option 2*/
  String verificationCode( String pin) {
    return "*${BaseUssdCodes.baseCodeUAT}*$pin*2#";
  }

  String checkBalance( String pin) {
    return "*${BaseUssdCodes.baseCodeUAT}*$pin*2#";
  }

  String rechargeNTC(
    String phoneNumberToRecharge,
    String pin,
    String amount,
  ) {
    return "*${BaseUssdCodes.baseCodeUAT}*$pin*3*1*$phoneNumberToRecharge*$amount*$pin#";
  }

  String rechargeNcell(
    String phoneNumberToRecharge,
    String pin,
    String amount,
  ) {
    return "*${BaseUssdCodes.baseCodeUAT}*$pin*3*2*$phoneNumberToRecharge*$amount*$pin#";
  }
}
