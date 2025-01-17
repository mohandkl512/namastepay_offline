import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false, // Prevents closing the dialog by tapping outside
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 80.sp,
        width: 80.sp,
        color: Colors.white54,
        child: Center(
          child: SizedBox(
            height: 24.sp,
            width: 24.sp,
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}
