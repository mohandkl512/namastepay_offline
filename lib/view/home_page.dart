import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/main.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/unknown_page.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/utils/custom_toast.dart';
import 'package:ussd_npay/utils/images.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/utils/npay_texts.dart';
import 'package:ussd_npay/viewmodels/home_cubit.dart';
import 'package:ussd_npay/viewmodels/profile_cubit.dart';
import 'package:ussd_npay/viewmodels/states/home_state.dart';
import 'package:ussd_npay/viewmodels/states/verification_state.dart';
import 'package:ussd_npay/widgets/user_service.dart';
import '../authentication_provider.dart';
import '../utils/namaste_pay_icons.dart';
import '../utils/string_modification.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Initial index of the selected item
  bool amountVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: Scaffold(
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
                  color: AppColors.appBarColorBlueTop,
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index; // Update the selected index
            });
          }, // Set the onTap function to update the index

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset(
            namastePayLogo,
            height: 8.h,
            width: 48.w,
          ),
          actions: [
            IconButton.outlined(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.login,
                  (_) => false,
                );
              },
              icon: Icon(
                Icons.logout_outlined,
                size: 4.w,
              ),
            )
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.sp),
            BlocConsumer<HomeCubit, ServiceState>(
              listener: (context, homeState) {
                if (homeState is ServiceLoading) {
                  showLoadingDialog(context);
                } else if (homeState is ServiceSelected) {
                  Navigator.pop(context);
                } else if (homeState is ServiceError) {
                  Navigator.pop(context);
                }
              },
              builder: (context, homeState) {
                final AuthenticationProvider authProvider =
                    getIt<AuthenticationProvider>();

                Verified verified = authProvider.authState as Verified;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.sp,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 10.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12), // Adjust as needed
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 218, 158, 98), // Bronze color
                          Color.fromARGB(255, 221, 168, 114), // Bronze color
                          Color.fromARGB(255, 238, 198, 158), // Bronze color
                          Color.fromARGB(
                              255, 216, 178, 139), // Darker bronze color
                          Color.fromARGB(
                              255, 207, 160, 114), // Darker bronze color
                        ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF8B4513), // Dark shadow
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0xFFFFDAB9), // Light shadow
                          offset: Offset(-2.0, -2.0),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Image.asset(
                                NamastePayIcons.walletBalance,
                                width: 16.sp,
                                height: 16.sp,
                              ),
                              SizedBox(width: 8.sp),
                              Text(
                                "Main Balance",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              NpayTexts.rs,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                amountVisible
                                    ? getAmountOnly(verified.sucessMessage ??
                                            "XXXXXX") ??
                                        ""
                                    : "XXXXXX",
                                // style: theme.textTheme.bodyLarge,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (!amountVisible) {
                                  final homeCubit = context.read<HomeCubit>();
                                  await homeCubit.checkBalance();
                                  amountVisible = true;
                                } else {
                                  setState(() {
                                    amountVisible = false;
                                  });
                                }
                              },
                              icon: Icon(
                                amountVisible
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye,
                                size: 20.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Available Services',
                      style: Theme.of(context).textTheme.labelMedium),
                  Text('View All',
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
            Wrap(
              runAlignment: WrapAlignment.start,
              runSpacing: 16.sp,
              spacing: 8.sp,
              alignment: WrapAlignment.start,
              children: [
                // MaterialButton(
                //   onPressed: () async {
                //     final homeCubit = context.read<HomeCubit>();
                //     await homeCubit.checkBalance();
                //   },
                //   child: const UserService(
                //       name: "Check Balance", icon: Icons.account_balance),
                // ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.topup);
                  },
                  child: const UserService(
                    name: "Topup",
                    icon: Icons.mobile_friendly,
                    imageUrl: NamastePayIcons.mobileRecharge,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.sendMoney);
                  },
                  child: const UserService(
                    name: "Send Money",
                    icon: Icons.money,
                    imageUrl: NamastePayIcons.sendMoney,
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
                    imageUrl: NamastePayIcons.landline,
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    // showCustomToast(context, "Service In Progress");
                    Navigator.pushNamed(context, RoutesName.ispListPage);
                  },
                  child: const UserService(
                    name: "Internet",
                    icon: Icons.wifi,
                    imageUrl: NamastePayIcons.internet,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.tvPaymentPage);
                  },
                  child: const UserService(
                    name: "TV",
                    icon: Icons.tv,
                    imageUrl: NamastePayIcons.tv,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    showCustomToast(context, "feature in progress");
                  },
                  child: const UserService(
                    name: "Electricity",
                    icon: Icons.e_mobiledata,
                    imageUrl: NamastePayIcons.electricity,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.cashoutPage);
                  },
                  child: const UserService(
                    name: "Cash Out",
                    icon: Icons.money_outlined,
                    imageUrl: NamastePayIcons.cashout,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.internalRemit);
                  },
                  child: const UserService(
                    name: "Internal Remit",
                    icon: Icons.money_outlined,
                    imageUrl: NamastePayIcons.remittance,
                  ),
                ),
              ],
            ),
          ],
        );

      case 1:
        return const ProfilePage();
      default:
        return const UnknownPage();
    }
  }
}
