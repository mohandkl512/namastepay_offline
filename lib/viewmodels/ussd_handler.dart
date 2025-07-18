import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_npay/authentication_provider.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/display_message.dart';
import 'package:ussd_npay/utils/error_message.dart';

import 'states/verification_state.dart';

class ServiceException implements Exception {
  final String message;
  ServiceException(this.message);

  @override
  String toString() => 'ServiceException: $message';
}

Future<void> sendUssdIfVerified({
  required String? Function(Verified verified) onVerified,
  required void Function(Verified verified, String? response) onResponse,
  required void Function(String error) onError,
}) async {
  final AuthenticationProvider authProvider = GetIt.I<AuthenticationProvider>();
  if (authProvider.authState is! Verified) {
    onError('Profile could not be verified.');
    return;
  }

  try {
    Verified verified = authProvider.authState as Verified;
    dPrint("ID: ${verified.subscriptionId}");
    String? code = onVerified(verified);
    dPrint("Code: $code");
    if (code != null) {
      String? response = await UssdAdvanced.sendAdvancedUssd(
        subscriptionId: verified.subscriptionId,
        code: code,
      );
      dPrint("Response: $response");
      verified.sucessMessage = response;
      onResponse(verified, response);
    }
  } on PlatformException catch (exception) {
    dPrint(exception.details);
    dPrint(exception.message);
    dPrint(exception.code);
    onError(ErrorMessage.unexpectedError);
  } on ServiceException catch (exception) {
    dPrint(exception.message);
    onError(exception.message);
  } on TimeoutException catch (exception) {
    dPrint(exception);
    onError(DisplayMessage.timeoutException);
  } catch (exception) {
    // TODO: handle this properly
    dPrint(exception);
    onError(ErrorMessage.unexpectedError);
  }
}
