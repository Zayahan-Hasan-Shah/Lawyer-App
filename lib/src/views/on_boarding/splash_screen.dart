import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/utils/app_launcher_manager.dart'; // for onboarding
import 'package:lawyer_app/src/core/utils/storage/storage_service.dart'; // for token
import 'package:lawyer_app/src/routing/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
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
        log(
          "SplashScreen → User already logged in (token found). Going to Home.",
        );
        context.go(RouteNames.bottomNavigationScreen);
      } else {
        log(
          "SplashScreen → No token found. Going to Incoming User Type screen.",
        );
        context.go(RouteNames.incomingUserScreen);
      }
    } catch (e) {
      log("SplashScreen → Error during navigation decision: $e");
      context.go(RouteNames.incomingUserScreen);
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
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              AppAssets.logoImage,
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
