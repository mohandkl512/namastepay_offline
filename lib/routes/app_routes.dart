import 'package:flutter/material.dart';
import 'package:ussd_npay/login_page.dart';
import 'package:ussd_npay/view/cashout_page.dart';
import 'package:ussd_npay/view/change_pin_page.dart';
import 'package:ussd_npay/view/home_page.dart';
import 'package:ussd_npay/view/internal_remit.dart';
import 'package:ussd_npay/view/internet_payment_page.dart';
import 'package:ussd_npay/view/isp_listing_page.dart';
import 'package:ussd_npay/view/landline_recharge_page.dart';
import 'package:ussd_npay/view/recharge_screen.dart';
import 'package:ussd_npay/view/request_money_page.dart';
import 'package:ussd_npay/view/send_money_page.dart';
import 'package:ussd_npay/view/tv_payment_page.dart';

import 'route_path.dart';

class AppRoutes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    // route setting request cases
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case RoutesName.login:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case RoutesName.topup:
        return MaterialPageRoute(builder: (context) => const RechargeScreen());
      case RoutesName.requestMoney:
        return MaterialPageRoute(
            builder: (context) => const RequestMoneyScreen());
      case RoutesName.sendMoney:
        return MaterialPageRoute(builder: (context) => const SendMoneyScreen());
      case RoutesName.landlineRecharge:
        return MaterialPageRoute(
            builder: (context) => const LandlineRechargePage());
      case RoutesName.tvPaymentPage:
        return MaterialPageRoute(builder: (context) => const TvPaymentPage());
      case RoutesName.internetPaymentPage:
        return MaterialPageRoute(
          builder: (context) {
            final args = settings.arguments as Map;
            return InternetPaymentPage(ispName: args['isp_name']);
          },
        );
      case RoutesName.ispListPage:
        return MaterialPageRoute(builder: (context) => const IspListingPage());
      case RoutesName.changePinPage:
        return MaterialPageRoute(builder: (context) => const ChangePinPage());
      case RoutesName.cashoutPage:
        return MaterialPageRoute(builder: (context) => const CashoutPage());
      case RoutesName.internalRemit:
        return MaterialPageRoute(builder: (context) => const InternalRemit());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("Page Not Found")),
          );
        });
    }
  }
}
