// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ussd_npay/utils/namaste_pay_icons.dart';

class ISP extends StatelessWidget {
  final String imageUrl;
  final String name;
  final Function() onSelected;
  const ISP({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onSelected(),
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  NamastePayIcons.ntc,
                  width: 8.w,
                  height: 8.w,
                ),
                SizedBox(width: 4.w),
                Text(name),
              ],
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
