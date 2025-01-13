import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';
import '../authentication_provider.dart';
import '../utils/debug_print.dart';
import 'states/home_state.dart';
import 'states/verification_state.dart';

class TvCubit extends Cubit<ServiceState> {
  late UssdMethods ussdMethods;

  TvCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(ServiceInitial());



  Future<void> internetPayment(
    String username,
  ) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();

      emit(ServiceLoading());
      try {
        if (authProvider.authState is Verified) {
          Verified verified = authProvider.authState as Verified;
          String requestMoneycode =
              ussdMethods.internetPayment(username, verified.pin);
          String? response = await UssdAdvanced.sendAdvancedUssd(
            code: requestMoneycode,
            subscriptionId: verified.subscriptionId,
          );
          dPrint(response);
          // emit(ServiceSelected(response));
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
