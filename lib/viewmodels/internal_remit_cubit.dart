import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';

import 'states/internal_remit_state.dart';
import 'ussd_handler.dart';

class InternalRemitCubit extends Cubit<InternalRemitState> {
  InternalRemitCubit() : super(InternalRemitInitial());

  Future<void> processInternalRemit(String receiverNumber, int amount) async =>
      sendUssdIfVerified(
        onVerified: (verified) {
          emit(RemitProcessing());
          return UssdMethods.internalRemit(
              verified.pin, receiverNumber, amount);
        },
        onResponse: (_, response) {
          if (response == null) {
            emit(RemitError(DisplayMessage.unexpectedError));
          } else if (response
              .toLowerCase()
              .contains(ErrorMessage.trasactionAmount.toLowerCase())) {
            emit(RemitError(response));
          } else if (response
              .toLowerCase()
              .contains(ErrorMessage.transactionFailed.toLowerCase())) {
            emit(RemitError(response));
          } else if (response
              .toLowerCase()
              .contains(ErrorMessage.genericError.toLowerCase())) {
            emit(RemitError(DisplayMessage.unexpectedError));
          } else {
            emit(RemitDone(amount, response));
          }
        },
        onError: (error) => emit(RemitError(error)),
      );
}
