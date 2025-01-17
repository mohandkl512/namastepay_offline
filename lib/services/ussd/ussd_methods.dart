import 'package:ussd_npay/utils/base_ussd_codes.dart';
import 'package:ussd_npay/utils/debug_print.dart';

class UssdMethods {
  /* This method directly checks account balance with provided pin. with option 2*/
  String verificationCode(String pin) {
    return "*${BaseUssdCodes.baseUSSDCode}*$pin*2#";
  }

  String checkBalance(String pin) {
    return "*${BaseUssdCodes.baseUSSDCode}*$pin*2#";
  }

  String rechargeNTC(
    String phoneNumberToRecharge,
    String pin,
    String amount,
  ) {
    return "*${BaseUssdCodes.baseUSSDCode}*$pin*3*1*$phoneNumberToRecharge*$amount*$pin#";
  }

  String rechargeNcell(
    String phoneNumberToRecharge,
    String pin,
    String amount,
  ) {
    return "*${BaseUssdCodes.baseUSSDCode}*$pin*3*2*$phoneNumberToRecharge*$amount*$pin#";
  }

  String requestMoney(
    String toContact,
    String pin,
    String amount,
  ) {
    return "*${BaseUssdCodes.baseUSSDCode}*$pin*4*2*$toContact*$amount*$pin#";
  }

  String sendMoney(
    String toContact,
    String pin,
    String amount,
  ) {
    /*
    * 1. P2P(Registered)
      2. To Bank (Bank Withdraw)
      3. Cashour via Agents
      4. Transfer to unregistered user
      This method only implements  feature P2P transfer 1. 
     */
    return "*${BaseUssdCodes.baseUSSDCode}*$pin*5*1*$toContact*$amount*$pin#";
  }

  String landlineRecharge(
    String toContact,
    String pin,
    String amount,
  ) {
    return "*${BaseUssdCodes.baseUSSDCode}*$pin*6*5*$toContact*$amount*$pin#";
  }

  String internetPayment(
    String username,
    String pin,
    String internetOption,
  ) {
    dPrint("*${BaseUssdCodes.baseUSSDCode}*$pin*6*1*$internetOption*$username*1*$pin#");
    return "*${BaseUssdCodes.baseUSSDCode}*$pin*6*1*$internetOption*${username.trim()}*1*$pin#";
  }

  String tvPayment({
    required String customerId,
    required String pin,
    required String tvOption,
    required String paymentOption,
  }) {
    dPrint(
        "*${BaseUssdCodes.baseUSSDCode}*$pin*6*2*$tvOption*$customerId*$paymentOption*$pin#");
    return "*${BaseUssdCodes.baseUSSDCode}*$pin*6*2*$tvOption*$customerId*$paymentOption*$pin#";
  }
}
