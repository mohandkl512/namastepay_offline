import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';
import 'package:ussd_npay/viewmodels/states/payment_state.dart';
import '../authentication_provider.dart';
import '../utils/debug_print.dart';
import 'states/verification_state.dart';

class PaymentsCubit extends Cubit<PaymentState> {
  late UssdMethods ussdMethods;

  PaymentsCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(PaymentInitial(0));

  Future<void> makePaymentUAT(String landline, int ispId, String amount) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    emit(PaymentProcessing());
    try {
      if (authProvider.authState is Verified) {
        Verified verified = authProvider.authState as Verified;
        String code = ussdMethods.ntInternetPayment(
            landline, verified.pin, ispId, int.parse(amount));
        dPrint(code);
        String? response = await UssdAdvanced.sendAdvancedUssd(
          code: code,
          subscriptionId: verified.subscriptionId,
        );
        dPrint(response);
        if (response?.toLowerCase().contains(
                "Amount should be greater Than or equal to  100"
                    .toLowerCase()) ??
            false) {
          emit(PaymentError(response ?? "Null"));
        } else {
          emit(PaymentDone(ispId, response));
        }
      } else {
        emit(PaymentError(DisplayMessage.unexpectedError));
      }
    } on PlatformException catch (exception) {
      dPrint(exception.details);
      dPrint(exception.message);
      dPrint(exception.code);
      emit(PaymentError(ErrorMessage.unexpectedError));
    }
  }
    Future<void> makePaymentLive(String landline, int ispId, String amount) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    emit(PaymentProcessing());
    try {
      if (authProvider.authState is Verified) {
        Verified verified = authProvider.authState as Verified;
        String code = ussdMethods.ntInternetPayment(
            landline, verified.pin, ispId, int.parse(amount));
        dPrint(code);
        String? response = await UssdAdvanced.sendAdvancedUssd(
          code: code,
          subscriptionId: verified.subscriptionId,
        );
        dPrint(response);
        if (response?.toLowerCase().contains(
                "Amount should be greater Than or equal to  100"
                    .toLowerCase()) ??
            false) {
          emit(PaymentError(response ?? "Null"));
        } else {
          emit(PaymentDone(ispId, response));
        }
      } else {
        emit(PaymentError(DisplayMessage.unexpectedError));
      }
    } on PlatformException catch (exception) {
      dPrint(exception.details);
      dPrint(exception.message);
      dPrint(exception.code);
      emit(PaymentError(ErrorMessage.unexpectedError));
    }
  }
}
