import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/error_message.dart';
import 'package:ussd_npay/utils/errors/auth_error_message.dart';
import 'package:ussd_npay/viewmodels/states/profile_state.dart';
import '../authentication_provider.dart';
import '../utils/debug_print.dart';
import 'states/verification_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getReferralCode() async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    Verified verified = authProvider.authState as Verified;

    if (authProvider.authState is Verified) {
      if ((authProvider.authState as Verified).referralCode == null) {
        emit(ProfileLoading());
        try {
          dPrint("ID: ${verified.subscriptionId}");
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: UssdMethods.getReferral(verified.pin),
            subscriptionId: verified.subscriptionId,
          );
          verified.sucessMessage = response;
          verified.referralCode = response;
          emit(ProfileLoaded(response, null));
        } on PlatformException catch (exception) {
          dPrint(exception.details);
          dPrint(exception.message);
          dPrint(exception.code);
          emit(ProfileError(ErrorMessage.unexpectedError));
        }
      } else {
        emit(ProfileLoaded(verified.referralCode, null));
      }
    } else {
      emit(ProfileError("Could not verify user."));
    }
  }

  Future<void> changePin(String newPin) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    emit(ProfileLoading());
    try {
      if (authProvider.authState is Verified) {
        Verified verified = authProvider.authState as Verified;
        dPrint("ID: ${verified.subscriptionId}");
        String? response = await UssdAdvanced.sendAdvancedUssd(
          code: UssdMethods.changePin(verified.pin, newPin),
          subscriptionId: verified.subscriptionId,
        );
        dPrint(response);
        if (response?.contains(AuthErrorMessage.samePassword) ?? false) {
          emit(ProfileError("Old Authentication Value Cannot be Used"));
        } else if (response?.toLowerCase().contains(
                  AuthErrorMessage.invalidPin.toLowerCase(),
                ) ??
            false) {
          emit(ProfileError(response ?? " Error Occured"));
        } else {
          verified.sucessMessage = response;
          emit(ProfileLoaded(response, newPin));
        }
      } else {
        emit(ProfileError("Could not verify user."));
      }
    } on PlatformException catch (exception) {
      dPrint(exception.details);
      dPrint(exception.message);
      dPrint(exception.code);
      emit(ProfileError(ErrorMessage.unexpectedError));
    }
  }
}
