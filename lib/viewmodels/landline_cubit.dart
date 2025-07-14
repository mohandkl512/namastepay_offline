import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';

import 'states/landline_recharge_state.dart';
import 'ussd_handler.dart';

class LandlineCubit extends Cubit<LandlineRechargeState> {
  LandlineCubit() : super(LandlineRechargeInitial(0));

  Future<void> payBill(int amount, String contactNum) async =>
      sendUssdIfVerified(
        onVerified: (verified) {
          // TODO: is this check necessary?
          if (!Utils.isPinValid(verified.pin)) {
            throw ServiceException(ErrorMessage.pinvalidationError);
          }

          emit(LandlineRecharging());
          return UssdMethods.landlineRecharge(
              contactNum, verified.pin, amount.toString());
        },
        onResponse: (_, response) {
          if (response
                  ?.toLowerCase()
                  .contains(ErrorMessage.transactionFailed.toLowerCase()) ??
              false) {
            emit(LandlineError(DisplayMessage.transactionFailed));
          } else if (response
                  ?.toLowerCase()
                  .contains(ErrorMessage.trasactionAmount.toLowerCase()) ??
              false) {
            emit(LandlineError(response ?? ''));
          } else {
            emit(LandlineRechargeSelected(response));
          }
        },
        onError: (error) => emit(LandlineError(error)),
      );

  void updateAmount(int amount) => emit(LandlineRechargeInitial(amount));
}
