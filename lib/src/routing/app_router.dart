import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/views/auth/forgot_password_screen.dart';
import 'package:lawyer_app/src/views/auth/login_screen.dart';
import 'package:lawyer_app/src/views/auth/otp_screen.dart';
import 'package:lawyer_app/src/views/auth/reset_password_screen.dart';
import 'package:lawyer_app/src/views/auth/signup_screen.dart';
import 'package:lawyer_app/src/views/bottom_navigation/bottom_navigation_screen.dart';
import 'package:lawyer_app/src/views/on_boarding/on_boarding_screen.dart';
import 'package:lawyer_app/src/views/on_boarding/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.splashScreen,
    routes: [
      GoRoute(
        path: RouteNames.splashScreen,
        name: RouteNames.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboardingScreen,
        name: RouteNames.onboardingScreen,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: RouteNames.signupScreen,
        name: RouteNames.signupScreen,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteNames.loginScreen,
        name: RouteNames.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPasswordScreen,
        name: RouteNames.forgotPasswordScreen,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.otpScreen,
        name: RouteNames.otpScreen,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: RouteNames.resetPasswordScreen,
        name: RouteNames.resetPasswordScreen,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.bottomNavigationScreen,
        name: RouteNames.bottomNavigationScreen,
        builder: (context, state) => const BottomNavigationScreen(),
      ),
    ],
  );
}
