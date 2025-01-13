import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/services/ussd/ussd_methods.dart';
import 'package:ussd_npay/viewmodels/landline_cubit.dart';
import 'package:ussd_npay/viewmodels/recharge_cubit.dart';
import 'package:ussd_npay/viewmodels/request_cubit.dart';
import 'package:ussd_npay/viewmodels/send_money_cubit.dart';
import 'package:ussd_npay/viewmodels/verification_cubit.dart';
import 'package:ussd_npay/viewmodels/states/verification_state.dart';
import 'authentication_provider.dart';
import 'routes/app_routes.dart';
import 'routes/route_path.dart';
import 'unknown_page.dart';
import 'viewmodels/home_cubit.dart';

final getIt = GetIt.instance;
void main(List<String> args) {
  setup();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VerificationCubit(),
        ),
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => RechargeCubit(),
        ),
        BlocProvider(
          create: (context) => RequestCubit(),
        ),
        BlocProvider(
          create: (context) => SendMoneyCubit(),
        ),
           BlocProvider(
          create: (context) => LandlineCubit(),
        ),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            // home: const LoginPage(),
            initialRoute: RoutesName.login,
            onGenerateRoute: AppRoutes.generateRoutes,
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => UnknownPage(routeName: settings.name),
              );
            },
          );
        },
      ),
    ),
  );
}

void setup() {
  getIt.registerSingleton<AuthenticationProvider>(
      AuthenticationProvider(VerificationInitial()));
  getIt.registerSingleton<UssdMethods>(UssdMethods());
}
