import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/app/router/route_names.dart';
import 'package:lawyer_app/core/constants/app_assets.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/auth/presentation/providers/login_provider.dart';
import 'package:lawyer_app/features/auth/presentation/states/login_state.dart';
import 'package:lawyer_app/shared/widgets/custom_button.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:lawyer_app/shared/widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next is LoginSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.kGoldDark,
          ),
        );
        context.go(RouteNames.bottomNavigationScreen);
      } else if (next is LoginFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

    final loginState = ref.watch(loginProvider);

    return Scaffold(
      backgroundColor: AppColors.kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 2.h),
                  Container(
                    height: 10.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kGold.withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      AppAssets.logoImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    title: "Welcome Back",
                    fontSize: 24.sp,
                    weight: FontWeight.w800,
                    color: AppColors.kGoldLight,
                  ),
                  SizedBox(height: 1.h),
                  CustomText(
                    title: "Login to your account to continue",
                    fontSize: 14.sp,
                    color: AppColors.kTextSecondary,
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.kSurfaceElevated.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.kBorderSubtle),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: emailController,
                          hintText: "Email Address",
                          prefixIcon: Icon(Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty ? "Enter email" : null,
                        ),
                        SizedBox(height: 2.h),
                        CustomTextField(
                          controller: passwordController,
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock_outline),
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.kGold,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter password" : null,
                        ),
                        SizedBox(height: 1.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                context.push(RouteNames.forgotPasswordScreen),
                            child: CustomText(
                              title: "Forgot Password?",
                              color: AppColors.kGold,
                              fontSize: 13.sp,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  CustomButton(
                    text: "Login",
                    isLoading: loginState is LoginLoading,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .read(loginProvider.notifier)
                            .login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                      }
                    },
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        title: "Don't have an account? ",
                        color: AppColors.kTextSecondary,
                        fontSize: 14.sp,
                      ),
                      GestureDetector(
                        onTap: () => context.push(RouteNames.signupScreen),
                        child: CustomText(
                          title: "Sign up",
                          color: AppColors.kGold,
                          weight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
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
