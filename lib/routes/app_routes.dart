import 'package:flutter/material.dart';
import 'package:ussd_npay/home_page.dart';
import 'package:ussd_npay/login_page.dart';

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

      // if non of these above cases are met then return this
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("Page Not Found")),
          );
        });
    }
  }
}
