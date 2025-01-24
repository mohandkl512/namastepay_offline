import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';
import 'package:ussd_npay/viewmodels/states/internal_remit_state.dart';
import '../authentication_provider.dart';
import '../utils/debug_print.dart';
import 'states/verification_state.dart';

class InternalRemitCubit extends Cubit<InternalRemitState> {
  late UssdMethods ussdMethods;

  InternalRemitCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(InternalRemitInitial());

  Future<void> processInternalRemit(String receiverNumber, int amount) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    try {
      if (authProvider.authState is Verified) {
        emit(RemitProcessing());
        Verified verified = authProvider.authState as Verified;
        dPrint("ID: ${verified.subscriptionId}");
        String? response = await UssdAdvanced.sendAdvancedUssd(
          code: ussdMethods.internalRemit(verified.pin, receiverNumber, amount),
          subscriptionId: verified.subscriptionId,
        );
        dPrint("Response: $response");
        verified.sucessMessage = response;
        if (response
                ?.toLowerCase()
                .contains(ErrorMessage.trasactionAmount.toLowerCase()) ??
            false) {
          emit(RemitError(response ?? "Unexpeced Error Occured"));
        } else if (response
                ?.toLowerCase()
                .contains(ErrorMessage.transactionFailed.toLowerCase()) ??
            false) {
          emit(RemitError(response ?? "Unexpeced Error Occured"));
        } else if (response == null) {
          emit(RemitError(DisplayMessage.unexpectedError));
        } else if (response
            .toLowerCase()
            .contains(ErrorMessage.genericError.toLowerCase())) {
          emit(RemitError(DisplayMessage.unexpectedError));
        } else {
          emit(RemitDone(amount, response));
        }
      } else {
        emit(RemitError(DisplayMessage.unexpectedError));
      }
    } on PlatformException catch (exception) {
      dPrint(exception.details);
      dPrint(exception.message);
      dPrint(exception.code);
      emit(RemitError(ErrorMessage.unexpectedError));
    }
  }
}
