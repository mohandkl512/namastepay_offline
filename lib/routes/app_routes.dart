import 'package:flutter/material.dart';
import 'package:ussd_npay/home_page.dart';
import 'package:ussd_npay/login_page.dart';
import 'package:ussd_npay/view/landline_recharge_page.dart';
import 'package:ussd_npay/view/landline_sucess_page.dart';
import 'package:ussd_npay/view/recharge_screen.dart';
import 'package:ussd_npay/view/request_sucess.dart';
import 'package:ussd_npay/view/send_money_page.dart';
import 'package:ussd_npay/view/recharge_sucess_screen.dart';
import '../view/request_money_page.dart';
import '../view/sucess_money_send.dart';
import 'route_path.dart';

class AppRoutes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    // route setting request cases
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomePage());

      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage());
      case RoutesName.topup:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RechargeScreen());
      case RoutesName.requestMoney:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RequestMoneyScreen());
      case RoutesName.rechargeComplete:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SuccessScreen());
      case RoutesName.sendMoney:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SendMoneyScreen());
      case RoutesName.requestCompleted:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RequestSucess());
      case RoutesName.moneySent:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SucessMoneySend());
      case RoutesName.landlineRecharge:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LandlineRechargePage());
      case RoutesName.landlineSucess:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                const LandlineSucessPage()); // if none of these above cases are met then return this
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("Page Not Found")),
          );
        });
    }
  }
}
