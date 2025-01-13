import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/viewmodels/states/send_money_state.dart';
import '../authentication_provider.dart';
import '../utils.dart';
import '../utils/debug_print.dart';
import '../utils/display_message.dart';
import '../utils/error_message.dart';
import 'states/verification_state.dart';

class SendMoneyCubit extends Cubit<SendMoneyState> {
  late UssdMethods ussdMethods;

  SendMoneyCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(SendMoneyInitial(0));

  void updateAmount(int amount) {
    emit(SendMoneyInitial(amount));
  }

  Future<void> sendMoney(
    String toContact,
    int amount,
  ) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    Verified verified = authProvider.authState as Verified;

    if (!Utils.isValidPhoneNumber(toContact)) {
      emit(SendMoneyError(ErrorMessage.phoneValidationError));
    } else if (!Utils.isPinValid(verified.pin)) {
      emit(SendMoneyError(ErrorMessage.pinvalidationError));
    } else {
      emit(SendingMoney());
      try {
        if (authProvider.authState is Verified) {
          String sendMoneyCode =
              ussdMethods.sendMoney(toContact, verified.pin, amount.toString());
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: sendMoneyCode,
            subscriptionId: verified.subscriptionId,
          );
          if (response != null &&
              response.contains(ErrorMessage.transactionFailed)) {
            dPrint("Send Money Error: $response");
            emit(SendMoneyError(response));
          } else {
            dPrint(response);
            emit(SentMoney(response));
          }
        }
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(SendMoneyError(ErrorMessage.unexpectedError));
      } on TimeoutException catch (exception) {
        dPrint(exception);
        emit(SendMoneyError(DisplayMessage.timeoutException));
      } on MissingPluginException catch (exception) {
        dPrint(exception);
        emit(SendMoneyError(DisplayMessage.unexpectedError));
      }
    }
  }
}
