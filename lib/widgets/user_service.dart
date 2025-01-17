import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/utils/app_colors.dart';

class UserService extends StatelessWidget {
  final String name;
  final IconData icon;
  final String? imageUrl;

  const UserService({
    super.key,
    required this.name,
    required this.icon,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.sp),
      ),
      padding: const EdgeInsets.all(4.0),
      width: 16.w,
      height: 8.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          imageUrl == null
              ? Icon(
                  icon,
                  size: 20.sp,
                )
              : Image.asset(
                  imageUrl!,
                  width: 20.sp,
                  height: 20.sp,
                  color: AppColors.appBarColorBlueBottom,
                ),
          SizedBox(height: 8.sp),
          Flexible(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
