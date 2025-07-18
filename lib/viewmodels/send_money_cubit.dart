import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/error_message.dart';

import 'states/send_money_state.dart';
import 'ussd_handler.dart';

class SendMoneyCubit extends Cubit<SendMoneyState> {
  SendMoneyCubit() : super(SendMoneyInitial(0));

  void updateAmount(int amount) => emit(SendMoneyInitial(amount));

  Future<void> sendMoney(String toContact, int amount) async =>
      sendUssdIfVerified(
        onVerified: (verified) {
          // TODO: are these checks necessary?
          if (!Utils.isValidPhoneNumber(toContact)) {
            throw ServiceException(ErrorMessage.phoneValidationError);
          } else if (!Utils.isPinValid(verified.pin)) {
            throw ServiceException(ErrorMessage.pinvalidationError);
          }

          emit(SendingMoney());
          return UssdMethods.sendMoney(
              toContact, verified.pin, amount.toString());
        },
        onResponse: (_, response) {
          if (response
                  ?.toLowerCase()
                  .contains(ErrorMessage.transactionFailed.toLowerCase()) ??
              false) {
            emit(SendMoneyError(response ?? ''));
          } else {
            emit(SentMoney(response));
          }
        },
        onError: (error) => emit(SendMoneyError(error)),
      );
}
