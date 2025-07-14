import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';
import 'package:ussd_npay/utils/sim_type.dart';

import 'states/recharge_state.dart';
import 'ussd_handler.dart';

class RechargeCubit extends Cubit<RechargeState> {
  RechargeCubit() : super(RechargeInitial(0));

  Future<void> rechargeNamaste(int amount, String contactNum) async =>
      _recharge(amount, contactNum, UssdMethods.rechargeNTC);

  Future<void> rechargeNcell(int amount, String contactNum) async =>
      _recharge(amount, contactNum, UssdMethods.rechargeNcell);

  void updateAmount(int amount) => emit(RechargeInitial(amount));

  Future<void> _recharge(
          int amount,
          String contactNum,
          // TODO: use typedef
          String Function(
            String phoneNumberToRecharge,
            String pin,
            String amount,
          ) generateRechargeCode) async =>
      sendUssdIfVerified(
        onVerified: (verified) {
          if (!Utils.isValidPhoneNumber(contactNum)) {
            throw ServiceException(ErrorMessage.phoneValidationError);
          }

          emit(Recharging());
          return generateRechargeCode(
              contactNum, verified.pin, amount.toString());
        },
        onResponse: (_, response) {
          if (response != null &&
              response
                  .toLowerCase()
                  .contains(ErrorMessage.transactionFailed.toLowerCase())) {
            emit(RechargeError(DisplayMessage.transactionFailed));
          } else {
            emit(RechargeSelected(SimType.ntc, response));
          }
        },
        onError: (error) => emit(RechargeError(error)),
      );
}
