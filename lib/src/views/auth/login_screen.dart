import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/validation/app_validation.dart';
import 'package:lawyer_app/src/providers/client_provider/auth_provider/login_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/client_states/auth_states/login_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      try {
        final response = await ref
            .read(loginProvider.notifier)
            .login(email: email, password: password);
        if (response != null) {
          log("LoginScreen → Login response: $response");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Login Successful'),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.go(RouteNames.bottomNavigationScreen);
        } else {
          log("LoginScreen → Login failed, response is null");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Invalid Login details. Please try again.'),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      } catch (e, st) {
        log("LoginScreen → Exception during Login: $e\n$st");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('An unexpected error occurred. Please try again.'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        title: "Sign in to access your cases",
                        color: AppColors.kTextSecondary,
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                _builEmailTextField(),
                SizedBox(height: 1.5.h),
                _builPasswordTextField(),
                SizedBox(height: 3.h),
                _buildForgetPassword(),
                SizedBox(height: 2.h),
                _buildSignupButton(),
                SizedBox(height: 1.h),
                _signupTagLine(),
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

  Widget _builEmailTextField() {
    return CustomTextField(
      controller: _emailController,
      hintText: "Email Address",
      prefixIcon: Icon(Icons.mail_rounded, color: AppColors.kEmerald, size: 22),
      validator: AppValidation.validateEmail,
      keyboardType: TextInputType.emailAddress,
      textColor: AppColors.kTextPrimary,
      hintTextColor: AppColors.kTextSecondary,
    );
  }

  Widget _builPasswordTextField() {
    return CustomTextField(
      controller: _passwordController,
      hintText: "Password",
      obscureText: _obscurePassword,
      validator: AppValidation.checkText,
      textColor: AppColors.kTextPrimary,
      hintTextColor: AppColors.kTextSecondary,
      prefixIcon: Icon(Icons.lock_rounded, color: AppColors.kEmerald, size: 22),
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_off_rounded
              : Icons.visibility_rounded,
          color: AppColors.kEmerald.withOpacity(0.8),
          size: 22,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
    );
  }

  Widget _buildForgetPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            context.push(RouteNames.forgotPasswordScreen);
          },
          child: CustomText(
            title: "Forget Password?",
            fontSize: 16.sp,
            color: AppColors.kEmerald,
            weight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton() {
    final loginState = ref.watch(loginProvider);
    return SizedBox(
      width: double.infinity,
      height: 14.w,
      child: loginState is LoginLoading
          ? const Center(child: LoadingIndicator())
          : CustomButton(
              text: 'Sign In',
              onPressed: _login,
              gradient: LinearGradient(
                colors: [AppColors.kEmerald, AppColors.kEmeraldDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              textColor: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              borderRadius: 16,
            ),
    );
  }

  Widget _signupTagLine() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have a  account?",
          style: TextStyle(color: AppColors.hintTextColor, fontSize: 16.sp),
          children: [
            TextSpan(
              text: ' Sign up',
              style: TextStyle(color: AppColors.kEmerald),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.go(RouteNames.signupScreen);
                },
            ),
          ],
        ),
      ),
    );
  }
}
