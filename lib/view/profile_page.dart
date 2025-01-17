
// Profile Page (Feature in Progress)
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 60,
            color: Colors.green,
          ),
          SizedBox(height: 20),
          Text(
            'Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Icon(
            Icons.lock,
            size: 60,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            'Feature in Progress',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}