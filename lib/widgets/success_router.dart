import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/utils/error_dialog.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/view/success_page.dart';
import 'package:ussd_npay/viewmodels/states/service_state.dart';

class SuccessRouter<B extends Cubit<S>, S extends ServiceBaseState> extends StatelessWidget {
  const SuccessRouter({super.key, required this.child});

  final Widget child;

  // TODO: use pushNamed instead?
  void _navigate(BuildContext context, ServiceBaseState state) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SuccessPage(state: state)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      child: child,
      listener: (context, state) {
        dPrint('Current State: $state');
        switch (state) {
          case ServiceSuccessState _:
            _navigate(context, state);
          case ServiceErrorState error:
            showErrorDialog(context, 'Error Occured', error.message);
            _navigate(context, state);
          case ServiceLoadingState _:
            showLoadingDialog(context);
        }
      },
    );
  }
}
