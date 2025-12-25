
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class IncomingUserCard extends ConsumerWidget {
  final void Function(WidgetRef ref, BuildContext context) onTap;
  final IconData icon;
  final String title;
  final String description;

  const IncomingUserCard({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => onTap(ref, context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.yellowAccent.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.yellowAccent, size: 8.h),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
