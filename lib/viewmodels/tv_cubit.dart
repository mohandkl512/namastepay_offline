import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/error_message.dart';

import 'states/tv_state.dart';
import 'ussd_handler.dart';

class TvCubit extends Cubit<TvState> {
  TvCubit() : super(TvInitial(amount: 0));

  Future<void> makePayment(
    String customerId,
    String selectedTv,
    String selectedPaymentOption,
  ) async =>
      sendUssdIfVerified(
        onVerified: (verified) {
          emit(TvRequestLoading());
          return UssdMethods.tvPayment(
            customerId: customerId,
            pin: verified.pin,
            tvOption: selectedTv,
            paymentOption: selectedPaymentOption,
          );
        },
        onResponse: (_, response) {
          if (response
                  ?.toLowerCase()
                  .contains(ErrorMessage.invalidCustomerId.toLowerCase()) ??
              false) {
            emit(TvRequestError(response ?? ''));
          } else {
            emit(TvRequestSucessfull(response));
          }
        },
        onError: (error) => emit(TvRequestError(error)),
      );
}
