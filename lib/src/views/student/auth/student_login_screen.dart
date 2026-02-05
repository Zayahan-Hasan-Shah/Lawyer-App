import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/validation/app_validation.dart';
import 'package:lawyer_app/src/providers/student_provider/student_auth_provider/student_login_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/student_states/student_auth_state/student_login_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class StudentLoginScreen extends ConsumerStatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  ConsumerState<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends ConsumerState<StudentLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _studentLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await ref
          .read(studentLoginProvider.notifier)
          .studentlLogin(email: email, password: password);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Login Successful"),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        _showErrorSnackBar("Invalid credentials");
      }
    } catch (e) {
      log("Login error: $e");
      _showErrorSnackBar("Something went wrong. Please try again.");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isloading = ref.watch(studentLoginProvider) is StudentLoginLoading;
    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 14.h,
                        width: 38.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.kEmerald.withOpacity(0.18),
                              blurRadius: 32,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          AppAssets.logoImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 3.5.h),
                      CustomText(
                        title: "Welcome",
                        fontSize: 20.sp,
                        color: AppColors.kTextPrimary,
                      ),
                      SizedBox(height: 0.8.h),
                      CustomText(
                        title: "Sign in to progress your education",
                        color: AppColors.kTextSecondary,
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 6.h),

                CustomTextField(
                  controller: _emailController,
                  hintText: "Email Address",
                  prefixIcon: Icon(
                    Icons.mail_rounded,
                    color: AppColors.kEmerald,
                    size: 22,
                  ),
                  validator: AppValidation.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textColor: AppColors.kTextPrimary,
                  hintTextColor: AppColors.kTextSecondary,
                ),

                SizedBox(height: 2.4.h),

                CustomTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  obscureText: _obscurePassword,
                  validator: AppValidation.checkText,
                  textColor: AppColors.kTextPrimary,
                  hintTextColor: AppColors.kTextSecondary,
                  prefixIcon: Icon(
                    Icons.lock_rounded,
                    color: AppColors.kEmerald,
                    size: 22,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.kEmerald.withOpacity(0.8),
                      size: 22,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),

                SizedBox(height: 4.5.h),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: isloading
                      ? const Center(
                          child: LoadingIndicator(color: AppColors.kEmerald),
                        )
                      : CustomButton(
                          text: "Sign in",
                          onPressed: _studentLogin,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.kEmerald,
                              AppColors.kEmeraldDark,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          textColor: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          borderRadius: 16,
                        ),
                ),

                SizedBox(height: 4.h),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.kTextSecondary,
                        fontSize: 15.sp,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: AppColors.kEmerald,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                context.go(RouteNames.studentSignupScreen),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 5.h),

                // Back to role selection
                TextButton(
                  onPressed: () => context.go(RouteNames.incomingUserScreen),
                  child: Text(
                    '← Back to Role Selection',
                    style: TextStyle(
                      color: AppColors.kTextSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
