import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserService extends StatelessWidget {
  final String name;
  final IconData icon;

  const UserService({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.sp),
        color: Colors.grey.shade200,
      ),
      margin: EdgeInsets.all(8.sp),
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(height: 8.sp),
          Text(name),
        ],
      ),
    );
  }
}
