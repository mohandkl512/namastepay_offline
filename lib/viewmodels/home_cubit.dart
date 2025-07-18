import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';

import 'states/home_state.dart';
import 'ussd_handler.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> checkBalance() async =>
    sendUssdIfVerified(
      onVerified: (verified) {
        emit(HomeLoading());
        return UssdMethods.checkBalance(verified.pin);
      },
      onResponse: (_, response) {
        emit(HomeSelected(response));
      },
      onError: (error) => emit(HomeError(error)),
    );
}
