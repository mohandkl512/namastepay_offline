import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/viewmodels/states/request_state.dart';
import '../authentication_provider.dart';
import '../utils.dart';
import '../utils/debug_print.dart';
import '../utils/display_message.dart';
import '../utils/error_message.dart';
import 'states/verification_state.dart';

class RequestCubit extends Cubit<RequestState> {
  late UssdMethods ussdMethods;

  RequestCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(RequestInitial(0));

  void updateAmount(int amount) {
    emit(RequestInitial(amount));
  }

  Future<void> requestMoney(
    String toContact,
    int amount,
  ) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    Verified verified = authProvider.authState as Verified;

    if (!Utils.isValidPhoneNumber(toContact)) {
      emit(RequestError(ErrorMessage.phoneValidationError));
    } else if (!Utils.isPinValid(verified.pin)) {
      emit(RequestError(ErrorMessage.pinvalidationError));
    } else {
      emit(Requesting());
      try {
        if (authProvider.authState is Verified) {
          String requestMoneycode = ussdMethods.requestMoney(
              toContact, verified.pin, amount.toString());
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: requestMoneycode,
            subscriptionId: verified.subscriptionId,
          );
          if (response != null &&
              response.contains(ErrorMessage.transactionFailed)) {
            dPrint("Request Error: $response");
            emit(RequestError(response));
          } else {
            dPrint(response);
            emit(Requested(response));
          }
        }
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(RequestError(ErrorMessage.unexpectedError));
      } on TimeoutException catch (exception) {
        dPrint(exception);
        emit(RequestError(DisplayMessage.timeoutException));
      } on MissingPluginException catch (exception) {
        dPrint(exception);
        emit(RequestError(DisplayMessage.unexpectedError));
      }
    }
  }
}
