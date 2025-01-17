import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';
import 'package:ussd_npay/viewmodels/states/tv_state.dart';
import '../authentication_provider.dart';
import '../utils/debug_print.dart';
import 'states/verification_state.dart';

class TvCubit extends Cubit<TvState> {
  late UssdMethods ussdMethods;

  TvCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(TvInitial(amount: 0));

  Future<void> makePayment(
    String customerId,
    String selectedTv,
    String selectedPaymentOption,
  ) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();

    emit(TvRequestLoading());
    try {
      if (authProvider.authState is Verified) {
        Verified verified = authProvider.authState as Verified;
        String tvPayment = ussdMethods.tvPayment(
          customerId: customerId,
          pin: verified.pin,
          tvOption: selectedTv,
          paymentOption: selectedPaymentOption,
        );
        String? response = await UssdAdvanced.sendAdvancedUssd(
          code: tvPayment,
          subscriptionId: verified.subscriptionId,
        );
        dPrint(response);
        if (response?.contains(ErrorMessage.invalidCustomerId) ?? false) {
          emit(TvRequestError(response ?? "Unexpected Error  Error Occured"));
        } else {
          emit(TvRequestSucessfull(response));
        }
      }
    } on PlatformException catch (exception) {
      dPrint(exception.details);
      dPrint(exception.message);
      dPrint(exception.code);
      emit(TvRequestError(ErrorMessage.unexpectedError));
    } on TimeoutException catch (exception) {
      dPrint(exception);
      emit(TvRequestError(DisplayMessage.timeoutException));
    } on MissingPluginException catch (exception) {
      dPrint(exception);
      emit(TvRequestError(DisplayMessage.unexpectedError));
    }
  }
}
