import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/utils/isp_data.dart';
import 'package:ussd_npay/utils/namaste_pay_icons.dart';
import 'package:ussd_npay/widgets/isp.dart';

class IspListingPage extends StatelessWidget {
  const IspListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Internet"),
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 2.h),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: Text(
                "All ISP's",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ISP(
              imageUrl: NamastePayIcons.ntc,
              name: "NT ADSL",
              onSelected: () {
                Navigator.pushNamed(context, RoutesName.internetPaymentPage,
                    arguments: {
                      'isp_name': '${IspData.ntadsl}',
                    });
              },
            ),
            ISP(
              imageUrl: NamastePayIcons.ntc,
              name: "NT FTTH",
              onSelected: () {
                Navigator.pushNamed(context, RoutesName.internetPaymentPage,
                    arguments: {
                      'isp_name': '${IspData.ntffth}',
                    });
              },
            ),
          ],
        ));
  }
}
