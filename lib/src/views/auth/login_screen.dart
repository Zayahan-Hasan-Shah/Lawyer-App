import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/validation/app_validation.dart';
import 'package:lawyer_app/src/providers/auth_provider/login_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/auth_states/login_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_dialog.dart';
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
          showDialog(
            context: context,
            builder: (_) => CustomDialog(
              title: "Success",
              description: 'Login Successful!',
              buttonText: "Continue",
              icon: Icons.check_circle,
              onPressed: () {
                Navigator.pop(context);
                context.go(RouteNames.bottomNavigationScreen);
              },
              buttonGradient: const [Color(0xFF00FF7F), Color(0xFF006400)],
            ),
          );
        } else {
          log("LoginScreen → Login failed, response is null");
          _showErrorDialog(
            "Login Failed",
            "Invalid Login details. Please try again.",
          );
        }
      } catch (e, st) {
        log("LoginScreen → Exception during Login: $e\n$st");
        _showErrorDialog(
          "Error",
          "An unexpected error occurred. Please try again.",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(2.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  // width: double.infinity,
                  child: Image.asset(
                    AppAssets.logoImage,
                    alignment: Alignment.center,
                  ),
                ),
                CustomText(
                  title: "Sign In",
                  fontSize: 24.sp,
                  color: AppColors.whiteColor,
                  weight: FontWeight.bold,
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
      hintText: "Email",
      validator: AppValidation.validateEmail,
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
      prefixIcon: Icon(Icons.mail, color: AppColors.iconColor, size: 20),
    );
  }

  Widget _builPasswordTextField() {
    return CustomTextField(
      controller: _passwordController,
      hintText: "Password",
      validator: AppValidation.checkText,
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
      prefixIcon: Icon(Icons.lock, color: AppColors.iconColor, size: 20),
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: AppColors.iconColor,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
            log("LoginScreen → Password visibility: $_obscurePassword");
          });
        },
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
            color: AppColors.iconColor,
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
              fontSize: 16.sp,
              onPressed: _login,
              textColor: AppColors.blackColor,
              gradient: AppColors.buttonGradientColor,
              fontWeight: FontWeight.w600,
              borderRadius: 30,
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
              style: TextStyle(color: AppColors.iconColor),
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

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title,
        description: message,
        buttonText: "OK",
        icon: Icons.error_outline,
        buttonGradient: const [Color(0xFFFF6B6B), Color(0xFFC0392B)],
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
