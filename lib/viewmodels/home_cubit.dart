import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';

import 'states/home_state.dart';
import 'ussd_handler.dart';

class HomeCubit extends Cubit<ServiceState> {
  HomeCubit() : super(ServiceInitial());

  Future<void> checkBalance() async =>
    sendUssdIfVerified(
      onVerified: (verified) {
        emit(ServiceLoading());
        return UssdMethods.checkBalance(verified.pin);
      },
      onResponse: (_, response) {
        emit(ServiceSelected(response));
      },
      onError: (error) => emit(ServiceError(error)),
    );
}
