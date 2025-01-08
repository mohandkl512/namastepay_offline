import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/utils/images.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/utils/sim_type.dart';
import 'package:ussd_npay/view/recharge_page.dart';
import 'package:ussd_npay/viewmodels/home_cubit.dart';
import 'package:ussd_npay/viewmodels/states/home_state.dart';
import 'package:ussd_npay/widgets/user_service.dart';

import 'utils/string_modification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Inject dependency
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          namastePayLogo,
          height: 24.sp,
          width: size.width * 0.5,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Welcome!',
              style: TextStyle(fontSize: 24.sp),
            ),
          ),
          Center(
            child: Text(
              """This is your offline assitance for NamastePay ,
                Feel Free to explore!!!""",
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Services',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer<HomeCubit, ServiceState>(
            listener: (context, state) {
              if (state is ServiceSelected) {
                Navigator.pop(context);
                _showCustomDialog(context, "Your Account Balance",
                    findStringUntilNPR(state.serviceCode ?? "NULL NPR."));
              } else if (state is ServiceLoading) {
                showLoadingDialog(context);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        final homeCubit = context.read<HomeCubit>();
                        await homeCubit.checkBalance();
                      },
                      child: const UserService(
                          name: "Check Balance", icon: Icons.account_balance),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        _showRechargeDialog(context,SimType.ntc);
                      },
                      child: const UserService(
                          name: "NT Topup", icon: Icons.mobile_friendly),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        _showRechargeDialog(context,SimType.ncell);
                      },
                      child: const UserService(
                        name: "NCELL Topup",
                        icon: Icons.mobile_friendly,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _showCustomDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(title, textAlign: TextAlign.center),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showRechargeDialog(BuildContext context,SimType sim) {
    showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          title: const Text('Enter Details'),
          content: RechargePageDialog(simType: sim),
        );
      },
    );
  }
}
