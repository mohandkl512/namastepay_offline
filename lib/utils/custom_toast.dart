import 'package:flutter/material.dart';

void showCustomToast(BuildContext context,String message){
  WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red[400],
                duration: const Duration(seconds: 2),
              ),
            );
          });
}