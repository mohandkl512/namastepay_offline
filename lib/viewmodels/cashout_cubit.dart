import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';

import 'states/cashout_state.dart';
import 'ussd_handler.dart';

class CashoutCubit extends Cubit<CashoutState> {
  CashoutCubit() : super(CashoutInitial(0));

  Future<void> processCashout(String agentNumber, int amount) async =>
      sendUssdIfVerified(
        onVerified: (verified) {
          emit(CashoutProcessing());
          return UssdMethods.cashout(verified.pin, agentNumber, amount);
        },
        onResponse: (_, response) {
          if (response == null) {
            emit(CashoutError(DisplayMessage.unexpectedError));
          } else if (response
              .toLowerCase()
              .contains(ErrorMessage.trasactionAmount.toLowerCase())) {
            emit(CashoutError(response));
          } else if (response
              .toLowerCase()
              .contains(ErrorMessage.transactionFailed.toLowerCase())) {
            emit(CashoutError(response));
          } else if (response
              .toLowerCase()
              .contains(ErrorMessage.genericError.toLowerCase())) {
            emit(CashoutError(response));
          } else {
            emit(CashoutDone(amount, response));
          }
        },
        onError: (error) => emit(CashoutError(error)),
      );
}
