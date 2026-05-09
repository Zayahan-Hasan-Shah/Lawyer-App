import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FailedWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  const FailedWidget({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 60, color: Colors.red[400]),
        SizedBox(height: 2.h),
        Text(text, style: TextStyle(color: Colors.red[400])),
      ],
    );
  }
}
