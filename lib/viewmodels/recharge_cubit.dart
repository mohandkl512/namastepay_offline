import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';
import 'package:ussd_npay/utils/sim_type.dart';
import 'package:ussd_npay/viewmodels/states/recharge_state.dart';
import '../authentication_provider.dart';
import '../utils/debug_print.dart';
import 'states/verification_state.dart';

class RechargeCubit extends Cubit<RechargeState> {
  late UssdMethods ussdMethods;

  RechargeCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(RechargeInitial(0));

  Future<void> rechargeNamaste(
    String pin,
    int amount,
    String contactNum,
  ) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();

    if (!Utils.isValidPhoneNumber(contactNum)) {
      emit(RechargeError(ErrorMessage.phoneValidationError));
    }else {
      emit(Recharging());
      try {
        if (authProvider.authState is Verified) {
          Verified verified = authProvider.authState as Verified;
          String rechargeCode =
              ussdMethods.rechargeNTC(contactNum, verified.pin, amount.toString());
          dPrint("Recharge Code: $rechargeCode");
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: rechargeCode,
            subscriptionId: verified.subscriptionId,
          );
          if (response != null &&
              response.contains(ErrorMessage.transactionFailed)) {
            emit(RechargeError(DisplayMessage.transactionFailed));
          } else {
            emit(RechargeSelected(SimType.ntc, response));
          }
        }
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(RechargeError(ErrorMessage.unexpectedError));
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
      emit(RechargeError(ErrorMessage.phoneValidationError));
    } else {
      emit(Recharging());
      try {
        if (authProvider.authState is Verified) {
          Verified verified = authProvider.authState as Verified;
          String rechargeCode =
              ussdMethods.rechargeNcell(contactNum, verified.pin, amount.toString());
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: rechargeCode,
            subscriptionId: verified.subscriptionId,
          );
          dPrint(response);
          if (response != null &&
              response.contains(ErrorMessage.transactionFailed)) {
            emit(RechargeError(DisplayMessage.transactionFailed));
          } else {
            emit(RechargeSelected(SimType.ntc, response));
          }
        }
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(RechargeError(ErrorMessage.unexpectedError));
      }
    }
  }

  void updateAmount(int amount) {
    emit(RechargeInitial(amount));
  }
}
