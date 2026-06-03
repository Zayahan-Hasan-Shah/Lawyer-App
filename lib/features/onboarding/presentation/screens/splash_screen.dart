import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/core/constants/app_assets.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/core/utils/app_launcher_manager.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/app/router/route_names.dart';
import 'dart:developer';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _controller.forward();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    try {
      final bool isFirstLaunch = await AppLaunchManager.isFirstLaunch();
      if (isFirstLaunch) {
        context.go(RouteNames.onboardingScreen);
        return;
      }

      final String? token = await StorageService.instance.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final String? userType = await StorageService.instance.getUserType();
        log("Splash → Already logged in → userType: $userType");

        if (userType == "Lawyer") {
          context.go(RouteNames.lawyerBottomNavigationScreen);
        } else if (userType == "Student") {
          context.go(RouteNames.studentBottomNavigationScreen);
        } else {
          // Default to Client dashboard if type is Client, null or unrecognized
          context.go(RouteNames.bottomNavigationScreen);
        }
      } else {
        log("Splash → No token → Role overview");
        context.go(RouteNames.onboardingScreen);
      }
    } catch (e) {
      log("Splash navigation error: $e");
      context.go(RouteNames.roleOverviewScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2A2114), Color(0xFF140F0A)], // Dark gold tones
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kGold.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Image.asset(AppAssets.logoImage, width: 180, height: 180),
            ),
            const SizedBox(height: 60),
            Text(
              "JUSTICE",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                color: AppColors.kGoldLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "SIMPLIFIED",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                letterSpacing: 4,
                color: Colors.white.withOpacity(0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

