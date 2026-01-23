import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/utils/app_launcher_manager.dart';
import 'package:lawyer_app/src/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
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
        log("Splash → Already logged in → Home");
        context.go(RouteNames.bottomNavigationScreen);
      } else {
        log("Splash → No token → User type selection");
        context.go(RouteNames.incomingUserScreen);
      }
    } catch (e) {
      log("Splash navigation error: $e");
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
      backgroundColor: const Color(0xFF111111),
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
                  colors: [Color(0xFF1F2A44), Color(0xFF0F1625)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.35),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Image.asset(AppAssets.logoImage, width: 180, height: 180),
            ),
            const SizedBox(height: 60),
            const Text(
              "JUSTICE",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                color: Color(0xFF10B981), // emerald green
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
