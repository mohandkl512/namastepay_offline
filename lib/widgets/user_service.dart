import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
        color: Colors.grey.shade200,
      ),
      height: 100,
      padding: EdgeInsets.all(16.sp),
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
                ),
          SizedBox(height: 16.sp),
          SizedBox(
            width: 80,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                height: 4.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
