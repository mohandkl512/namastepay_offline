import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/authentication_provider.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/subscription_id.dart';
import 'package:ussd_npay/viewmodels/states/verification_state.dart';
import '../utils.dart';
import '../utils/errors/auth_error_message.dart';
import '../utils/response_message.dart';

class VerificationCubit extends Cubit<VerificationState> {
  late UssdMethods ussdMethods;

  VerificationCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(VerificationInitial());

  Future<void> validateAndSendUSSD(String phone, String pin) async {
    dPrint("validating user");
    if (!Utils.isValidPhoneNumber(phone)) {
      dPrint("phone not validated");
      emit(
        VerificationError('Phone numbers must be exactly 10 and only digits'),
      );
    } else if (!Utils.isPinValid(pin)) {
      emit(VerificationError('pin must be more than 4 characters!'));
    } else {
      emit(Verifying());
      final userId = await Utils.getSubscriptionId(phone);
      try {
        dPrint(userId);
        if (userId != SubscriptionID.auto) {
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: ussdMethods.verificationCode(pin),
            subscriptionId: userId,
          );
          dPrint(pin);
          dPrint("Message: $response");
          final message =
              checkMessageAndRespond(response ?? " some error occured. ");
          if (message == DisplayMessage.authenticated) {
            emit(Verified(pin, userId));
          } else {
            emit(VerificationError(message));
          }
          dPrint(response);
        } else {
          emit(
            VerificationError(
              "Phone number you enter should be in this device",
            ),
          );
        }
      } on PlatformException catch (exception) {
        dPrint(exception.details);
        dPrint(exception.message);
        dPrint(exception.code);
        emit(
          VerificationError(AuthErrorMessage.userNotRegistered),
        );
      }
      getIt.unregister<AuthenticationProvider>();
      getIt.registerLazySingleton<AuthenticationProvider>(
        () => AuthenticationProvider(
          Verified(pin, userId),
        ),
      );
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
