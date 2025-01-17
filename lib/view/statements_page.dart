

// Statements Page (Feature in Progress)
import 'package:flutter/material.dart';

class StatementsPage extends StatelessWidget {
  const StatementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment,
            size: 60,
            color: Colors.blue,
          ),
          SizedBox(height: 20),
          Text(
            'Statements',
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
