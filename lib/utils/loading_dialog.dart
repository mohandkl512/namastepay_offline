import 'package:flutter/material.dart';
import 'package:ussd_npay/utils/app_colors.dart';
import 'package:ussd_npay/widgets/FadingCube.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false, // Prevents closing the dialog by tapping outside
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.white.withAlpha(128),
        height: 100,
        width: 100,
        child: const SpinKitFadingCube(
          color: AppColors.appBarColorBlueBottom,
        ),
      );
    },
  );
}
