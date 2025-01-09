import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';
import '../authentication_provider.dart';
import '../utils/debug_print.dart';
import 'states/home_state.dart';
import 'states/verification_state.dart';

class HomeCubit extends Cubit<ServiceState> {
  late UssdMethods ussdMethods;

  HomeCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(ServiceInitial());

  Future<void> checkBalance() async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    emit(ServiceLoading());
    try {
      if (authProvider.authState is Verified) {
        Verified verified = authProvider.authState as Verified;

        String? response = await UssdAdvanced.sendAdvancedUssd(
          code: ussdMethods.checkBalance(verified.pin),
          subscriptionId: verified.subscriptionId,
        );
        emit(ServiceSelected(response));
      } else {
        emit(ServiceError(DisplayMessage.unexpectedError));
      }
    } on PlatformException catch (exception) {
      dPrint(exception.details);
      dPrint(exception.message);
      dPrint(exception.code);
      emit(ServiceError(ErrorMessage.unexpectedError));
    }
  }

  Future<void> rechargeNamaste(
    String pin,
    int amount,
    String contactNum,
  ) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();

    if (!Utils.isValidPhoneNumber(contactNum)) {
      emit(ServiceError(ErrorMessage.phoneValidationError));
    } else if (!Utils.isPinValid(pin)) {
      emit(ServiceError(ErrorMessage.pinvalidationError));
    } else {
      emit(ServiceLoading());
      try {
        if (authProvider.authState is Verified) {
          Verified verified = authProvider.authState as Verified;
          String rechargeCode =
              ussdMethods.rechargeNTC(contactNum, pin, amount.toString());
          dPrint("Recharge Code: $rechargeCode");
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: rechargeCode,
            subscriptionId: verified.subscriptionId,
          );
          dPrint(response);
          emit(ServiceSelected(response));
        }
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(ServiceError(ErrorMessage.unexpectedError));
      }
    }
  }

  Future<void> rechargeNcell(
    String pin,
    int amount,
    String contactNum,
  ) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();

    if (!Utils.isValidPhoneNumber(contactNum)) {
      emit(ServiceError(ErrorMessage.phoneValidationError));
    } else if (!Utils.isPinValid(pin)) {
      emit(ServiceError(ErrorMessage.pinvalidationError));
    } else {
      emit(ServiceLoading());
      try {
        if (authProvider.authState is Verified) {
          Verified verified = authProvider.authState as Verified;
          String rechargeCode =
              ussdMethods.rechargeNcell(contactNum, pin, amount.toString());
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: rechargeCode,
            subscriptionId: verified.subscriptionId,
          );
          dPrint(response);
          emit(ServiceSelected(response));
        }
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(ServiceError(ErrorMessage.unexpectedError));
      }
    }
  }

  Future<void> requestMoney(
    String toContact,
    int amount,
    String pin,
  ) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();

    if (!Utils.isValidPhoneNumber(toContact)) {
      emit(ServiceError(ErrorMessage.phoneValidationError));
    } else if (!Utils.isPinValid(pin)) {
      emit(ServiceError(ErrorMessage.pinvalidationError));
    } else {
      emit(ServiceLoading());
      try {
        if (authProvider.authState is Verified) {
          Verified verified = authProvider.authState as Verified;
          String requestMoneycode =
              ussdMethods.requestMoney(toContact, pin, amount.toString());
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: requestMoneycode,
            subscriptionId: verified.subscriptionId,
          );
          dPrint(response);
          emit(ServiceSelected(response));
        }
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(ServiceError(ErrorMessage.unexpectedError));
      } on TimeoutException catch (exception) {
        dPrint(exception);
        emit(ServiceError(DisplayMessage.timeoutException));
      } on MissingPluginException catch (exception) {
        dPrint(exception);
        emit(ServiceError(DisplayMessage.unexpectedError));
      }
    }
  }
  
  Future<void> sendMoney(
    String toContact,
    int amount,
    String pin,
  ) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();

    if (!Utils.isValidPhoneNumber(toContact)) {
      emit(ServiceError(ErrorMessage.phoneValidationError));
    } else if (!Utils.isPinValid(pin)) {
      emit(ServiceError(ErrorMessage.pinvalidationError));
    } else {
      emit(ServiceLoading());
      try {
        if (authProvider.authState is Verified) {
          Verified verified = authProvider.authState as Verified;
          String sendMoneyCode =
              ussdMethods.sendMoney(toContact, pin, amount.toString());
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: sendMoneyCode,
            subscriptionId: verified.subscriptionId,
          );
          dPrint(response);
          emit(ServiceSelected(response));
        }
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(ServiceError(ErrorMessage.unexpectedError));
      } on TimeoutException catch (exception) {
        dPrint(exception);
        emit(ServiceError(DisplayMessage.timeoutException));
      } on MissingPluginException catch (exception) {
        dPrint(exception);
        emit(ServiceError(DisplayMessage.unexpectedError));
      }
    }
  }
}
