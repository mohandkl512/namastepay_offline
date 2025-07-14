import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/errors/auth_error_message.dart';

import 'states/profile_state.dart';
import 'ussd_handler.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getReferralCode() async =>
      sendUssdIfVerified(
        onVerified: (verified) {
          if (verified.referralCode == null) {
            emit(ProfileLoading());
            return UssdMethods.getReferral(verified.pin);
          } else {
            emit(ProfileLoaded(verified.referralCode, null));
            return null;
          }
        },
        onResponse: (verified, response) {
          // TODO: check for errors?
          verified.referralCode = response;
          emit(ProfileLoaded(response, null));
        },
        onError: (error) => emit(ProfileError(error)),
      );

  Future<void> changePin(String newPin) async =>
      sendUssdIfVerified(
        onVerified: (verified) {
          emit(ProfileLoading());
          return UssdMethods.changePin(verified.pin, newPin);
        },
        onResponse: (verified, response) {
          if (response
                  ?.toLowerCase()
                  .contains(AuthErrorMessage.samePassword.toLowerCase()) ??
              false) {
            emit(ProfileError('Old Authentication Value Cannot be Used'));
          } else if (response
                  ?.toLowerCase()
                  .contains(AuthErrorMessage.invalidPin.toLowerCase()) ??
              false) {
            emit(ProfileError(response ?? ''));
          } else {
            emit(ProfileLoaded(response, newPin));
          }
        },
        onError: (error) => emit(ProfileError(error)),
      );
}
