import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/error_message.dart';

import 'states/payment_state.dart';
import 'ussd_handler.dart';

class PaymentsCubit extends Cubit<PaymentState> {
  PaymentsCubit() : super(PaymentInitial(0));

  Future<void> makePayment(String landline, int ispId, String amount) async =>
      sendUssdIfVerified(
        onVerified: (verified) {
          emit(PaymentProcessing());
          return UssdMethods.ntInternetPayment(
              landline, verified.pin, ispId, int.parse(amount));
        },
        onResponse: (_, response) {
          if (response
                  ?.toLowerCase()
                  .contains(ErrorMessage.trasactionAmount.toLowerCase()) ??
              false) {
            emit(PaymentError(response ?? ''));
          } else {
            emit(PaymentDone(ispId, response));
          }
        },
        onError: (error) => PaymentError(error),
      );
}
