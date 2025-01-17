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

class HomeCubit extends Cubit<ServiceState> {
  late UssdMethods ussdMethods;

  HomeCubit()
      : ussdMethods = getIt<UssdMethods>(),
        super(ServiceInitial());

  Future<void> checkBalance() async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    emit(ServiceLoading());
    try {
      if (authProvider.authState is Verified) {
        Verified verified = authProvider.authState as Verified;
        dPrint("ID: ${verified.subscriptionId}");
        String? response = await UssdAdvanced.sendAdvancedUssd(
          code: ussdMethods.checkBalance(verified.pin),
          subscriptionId: verified.subscriptionId,
        );
        emit(ServiceSelected(response));
      } else {
        emit(ServiceError(DisplayMessage.unexpectedError));
      }
    } on PlatformException catch (exception) {
      dPrint(exception.details);
      dPrint(exception.message);
      dPrint(exception.code);
      emit(ServiceError(ErrorMessage.unexpectedError));
    }
  }

  Future<void> internetPayment(String username, String isp) async {
    final AuthenticationProvider authProvider = getIt<AuthenticationProvider>();
    Verified verified = authProvider.authState as Verified;

    String _response = "empty";
    String? _res = await UssdAdvanced.multisessionUssd(
        code: "*114*6478*", subscriptionId: verified.subscriptionId);
    // setState(() {
    //   _response = _res ?? "";
    // });
    String? _res2 = await UssdAdvanced.sendMessage('2');
    // setState(() {
    //   _response = _res2 ?? "";
    // });
    await UssdAdvanced.cancelSession();
    dPrint(_response);
    // emit(ServiceLoading());
    // try {
    //   if (authProvider.authState is Verified) {
    //     Verified verified = authProvider.authState as Verified;
    //     String requestMoneycode =
    //         ussdMethods.internetPayment(username, verified.pin,isp);
    //     String? response = await UssdAdvanced.sendAdvancedUssd(
    //       code: requestMoneycode,
    //       subscriptionId: verified.subscriptionId,
    //     );
    //     dPrint(response);
    //     // emit(ServiceSelected(response));
    //   }
    // } on PlatformException catch (exception) {
    //   dPrint(exception.details);
    //   dPrint(exception.message);
    //   dPrint(exception.code);
    //   emit(ServiceError(ErrorMessage.unexpectedError));
    // } on TimeoutException catch (exception) {
    //   dPrint(exception);
    //   emit(ServiceError(DisplayMessage.timeoutException));
    // } on MissingPluginException catch (exception) {
    //   dPrint(exception);
    //   emit(ServiceError(DisplayMessage.unexpectedError));
    // }
  }
}
