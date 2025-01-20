import 'package:flutter/material.dart';
import 'package:ussd_npay/utils/isp_data.dart';
import 'package:ussd_npay/view/isps/ntadsl_payment.dart';
import 'package:ussd_npay/view/isps/ntftth_payment.dart';

class InternetPaymentPage extends StatelessWidget {
  final String ispName;

  const InternetPaymentPage({super.key, required this.ispName});

  @override
  Widget build(BuildContext context) {
    int ispId = int.parse(ispName);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Internet Payment"),
      ),
      body: _buildIspPage(ispId),
    );
  }

  String getName(int id) {
    switch (id) {
      case IspData.ntadsl:
        return "NT ADSL";
      case IspData.ntffth:
        return "NT FTTH";

      default:
        return "Not Available";
    }
  }

  _buildIspPage(int id) {
    switch (id) {
      case IspData.ntadsl:
        return const NtadslPayment(title: "NT ADSL");
      case IspData.ntffth:
        return const NtftthPayment(title: "NT FTTH");
      default:
        return const SizedBox();
    }
  }
}
