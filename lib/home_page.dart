import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/utils/custom_toast.dart';
import 'package:ussd_npay/utils/images.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
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
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'NamastePay',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          namastePayLogo,
          height: 24.sp,
          width: size.width * 0.5,
        ),
        actions: [
          IconButton.outlined(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutesName.login, (_) => false);
            },
            icon: const Icon(
              Icons.logout_outlined,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.sp),
          Center(
            child: Text(
              'Operate Offline @ \nNamastePay!!!',
              style: TextStyle(fontSize: 24.sp),
              textAlign: TextAlign.center,
            ),
          ),
          // Center(
          //   child: Text(
          //     """This is your offline assitance for NamastePay ,
          //       Feel Free to explore!!!""",
          //     style: TextStyle(fontSize: 16.sp),
          //   ),
          // ),
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
                    // color: Colors.grey,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 16.sp,
                    // color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          BlocListener<HomeCubit, ServiceState>(
              listener: (context, state) {
                if (state is ServiceSelected) {
                  Navigator.pop(context);
                  _showCustomDialog(context, "Your Account Balance",
                      findStringUntilNPR(state.serviceCode ?? "NULL NPR."));
                } else if (state is ServiceLoading) {
                  showLoadingDialog(context);
                }
              },
              child: Wrap(
                runAlignment: WrapAlignment.start,
                runSpacing: 16.sp,
                spacing: 8.sp,
                alignment: WrapAlignment.start,
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
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.topup);
                    },
                    child: const UserService(
                      name: "Topup",
                      icon: Icons.mobile_friendly,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.sendMoney);
                    },
                    child: const UserService(
                      name: "Send Money",
                      icon: Icons.money,
                      imageUrl: sendMoneyIcon,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.requestMoney);
                    },
                    child: const UserService(
                      name: "Request Money",
                      icon: Icons.request_quote,
                      imageUrl: requestMoneyIcon,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.landlineRecharge);
                    },
                    child: const UserService(
                      name: "Landline Recharge",
                      icon: Icons.request_quote,
                      imageUrl: landline,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      showCustomToast(context, "Service Not Available Yet");
                    },
                    child:
                        const UserService(name: "Internet", icon: Icons.wifi),
                  ),
                  MaterialButton(
                    onPressed: () {
                      showCustomToast(context, "Service in progress");
                    },
                    child: const UserService(name: "TV", icon: Icons.tv),
                  ),
                ],
              ))
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
}
