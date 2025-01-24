// Profile Page (Feature in Progress)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/utils/namaste_pay_icons.dart';
import 'package:ussd_npay/viewmodels/profile_cubit.dart';
import 'package:ussd_npay/viewmodels/states/profile_state.dart';
import '../utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (mounted) {
        final profileCubit = context.read<ProfileCubit>();
        profileCubit.getReferralCode();
      }
    });
  }

  void _copyToClipboard(BuildContext context, referralCode) {
    Clipboard.setData(ClipboardData(text: referralCode)); // Copy to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Referral Code copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              NamastePayIcons.referAndEarnImage,
              width: 100.w,
              height: 40.h,
            ),
            SizedBox(height: 4.h),
            Container(
              width: 100.w,
              height: 10.h,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.accentColor,
              ),
              child: Row(
                children: [
                  Text(
                    'Referral Code ',
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    (state is ProfileLoaded)
                        ? Utils.getCode(state.referalCode ?? " ")
                        : 'loading...',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 1.w),
                  state is ProfileLoaded
                      ? MaterialButton(
                          onPressed: () =>
                              _copyToClipboard(context, state.referalCode),
                          child: const Icon(
                            Icons.copy,
                            color: AppColors.containerPhoneNumBackgroundColor,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.changePinPage);
              },
              child: Container(
                width: 100.w,
                height: 8.h,
                margin: const EdgeInsets.only(left: 12, top: 12, right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.accentColor.withAlpha(80)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 4.w),
                    Image.asset(
                      NamastePayIcons.changePin,
                      height: 5.w,
                      width: 5.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Change Pin',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 5.w,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: const Divider(
                color: Colors.grey,
              ),
            )
          ],
        );
      },
    );
  }
}
