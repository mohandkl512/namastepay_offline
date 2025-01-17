import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sim_data/sim_data_model.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/authentication_provider.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/viewmodels/states/verification_state.dart';
import '../utils.dart';
import '../utils/errors/auth_error_message.dart';
import '../utils/response_message.dart';

class VerificationCubit extends Cubit<VerificationState> {
  late UssdMethods ussdMethods;

  VerificationCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(VerificationInitial());

  Future<void> validateAndSendUSSD(SimDataModel? sim, String pin) async {
    dPrint("validating user");
    if (!Utils.isPinValid(pin)) {
      emit(VerificationError('pin must be more than 4 characters!'));
    } else {
      emit(Verifying());
      // final userId = await Utils.getSubscriptionId(Utils.removePrefix(phone));
      final userId = sim?.subscriptionId ?? -1;
      try {
        String? response = await UssdAdvanced.sendAdvancedUssd(
          code: ussdMethods.verificationCode(pin),
          subscriptionId: userId,
        );
        final message =
            checkMessageAndRespond(response ?? " some error occured. ");
        if (message == DisplayMessage.authenticated) {
          emit(Verified(pin, userId, response));
        } else {
          emit(VerificationError(message));
        }
        getIt.unregister<AuthenticationProvider>();
        getIt.registerLazySingleton<AuthenticationProvider>(
          () => AuthenticationProvider(
            Verified(pin, userId, response),
          ),
        );
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(
          VerificationError(AuthErrorMessage.userNotRegistered),
        );
      } on TimeoutException catch (exception) {
        dPrint(exception);
        emit(VerificationError(DisplayMessage.timeoutException));
      } on MissingPluginException catch (exception) {
        dPrint(exception);
        emit(VerificationError(DisplayMessage.unexpectedError));
      }
    }
  }

  String checkMessageAndRespond(String message) {
    if (message.contains(ResponseMessage.accountBalanceSucecss)) {
      return DisplayMessage.authenticated;
    } else if (message.contains(AuthErrorMessage.invalidPinFirstAttempt)) {
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
