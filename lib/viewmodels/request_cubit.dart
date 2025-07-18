import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/error_message.dart';

import 'states/request_state.dart';
import 'ussd_handler.dart';

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(RequestInitial(0));

  Future<void> requestMoney(String toContact, int amount) async =>
      sendUssdIfVerified(
        onVerified: (verified) {
          if (!Utils.isValidPhoneNumber(toContact)) {
            throw (ServiceException(ErrorMessage.phoneValidationError));
          } else if (!Utils.isPinValid(verified.pin)) {
            throw (ServiceException(ErrorMessage.pinvalidationError));
          }

          emit(Requesting());
          return UssdMethods.requestMoney(
              toContact, verified.pin, amount.toString());
        },
        onResponse: (_, response) {
          if (response
                  ?.toLowerCase()
                  .contains(ErrorMessage.transactionFailed.toLowerCase()) ??
              false) {
            emit(RequestError(response ?? ''));
          } else {
            emit(Requested(response));
          }
        },
        onError: (error) => RequestError(error),
      );

  void updateAmount(int amount) => emit(RequestInitial(amount));
}
