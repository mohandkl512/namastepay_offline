  import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // The loading spinner
              SizedBox(width: 10),
              Text("Loading..."), // Text next to the spinner
            ],
          ),
        );
      },
    );
  }