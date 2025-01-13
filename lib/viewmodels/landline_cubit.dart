import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';
import 'package:ussd_npay/utils/errors/auth_error_message.dart';
import 'package:ussd_npay/viewmodels/states/landline_recharge_state.dart';
import '../authentication_provider.dart';
import '../utils/debug_print.dart';
import 'states/verification_state.dart';

class LandlineCubit extends Cubit<LandlineRechargeState> {
  late UssdMethods ussdMethods;

  LandlineCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(LandlineRechargeInitial(0));

  Future<void> payBill(
    int amount,
    String contactNum,
  ) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    Verified verified = authProvider.authState as Verified;

    if (!Utils.isPinValid(verified.pin)) {
      emit(LandlineError(ErrorMessage.pinvalidationError));
    } else {
      emit(LandlineRecharging());
      try {
        if (authProvider.authState is Verified) {
          String landlineRechargeCode = ussdMethods.landlineRecharge(
              contactNum, verified.pin, amount.toString());
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: landlineRechargeCode,
            subscriptionId: verified.subscriptionId,
          );
          dPrint(response);
          dPrint(response?.contains(ErrorMessage.trasactionAmount));
          if (response != null &&
              response.contains(ErrorMessage.transactionFailed)) {
            emit(LandlineError(DisplayMessage.transactionFailed));
          } else if (response != null &&
              response.contains(ErrorMessage.trasactionAmount)) {
            emit(LandlineError(response));
          } else {
            emit(LandlineRechargeSelected(response));
          }
        }
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(LandlineError(ErrorMessage.unexpectedError));
      }
    }
  }

  void updateAmount(int amount) {
    emit(LandlineRechargeInitial(amount));
  }

  String checkMessageAndRespond(String message) {
    if (message.contains(AuthErrorMessage.invalidPinFirstAttempt)) {
      return DisplayMessage.invalidPinFirstAttempt;
    } else if (message.contains(AuthErrorMessage.invalidPinSecondAttempt)) {
      return DisplayMessage.invalidPinSecondAttempt;
    } else if (message.contains(AuthErrorMessage.invalidPinThirdAttempt)) {
      return DisplayMessage.invalidPinSecondAttempt;
    } else if (message
        .contains(AuthErrorMessage.servicesCurrentlyNotAvailable)) {
      return DisplayMessage.servicesCurrentlyNotAvailable;
    } else if (message.contains(AuthErrorMessage.registrationFlowActive)) {
      return DisplayMessage.registrationFlowActive;
    } else {
      return DisplayMessage.unexpectedError;
    }
  }
}
