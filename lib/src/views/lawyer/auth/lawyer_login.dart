import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/validation/app_validation.dart';
import 'package:lawyer_app/src/providers/lawyer_provider/lawyer_auth_provider/lawyer_login_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/lawyer_states/lawyer_auth_state/lawyer_login_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class LawyerLogin extends ConsumerStatefulWidget {
  const LawyerLogin({super.key});

  @override
  ConsumerState<LawyerLogin> createState() => _LawyerLoginState();
}

class _LawyerLoginState extends ConsumerState<LawyerLogin> {
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

  Future<void> _lawyerLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      try {
        final response = await ref
            .read(lawyerLoginProvider.notifier)
            .lawyerLogin(email: email, password: password);
        if (response != null) {
          _showSnackBar("Login Successfull", isError: false);
          context.go(RouteNames.lawyerBottomNavigationScreen);
          log("LoginScreen → Login response: $response");
        } else {
          _showSnackBar("Login Failed", isError: true);
        }
      } catch (e) {
        log("LoginScreen → Exception during Login: $e");
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 1.h),
        child: TextButton(
          onPressed: () {
            context.go(RouteNames.incomingUserScreen);
          },
          child: CustomText(
            title: 'Back to Main Menu',
            color: AppColors.hintTextColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(2.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                _buildSignupButton(),
                SizedBox(height: 2.h),
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
      obscureText: _obscurePassword,
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

  Widget _buildSignupButton() {
    final loginState = ref.watch(lawyerLoginProvider);
    return SizedBox(
      width: double.infinity,
      height: 14.w,
      child: loginState is LawyerLoginLoading
          ? const Center(child: LoadingIndicator())
          : CustomButton(
              text: 'Sign In',
              fontSize: 16.sp,
              onPressed: _lawyerLogin,
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
                  context.go(RouteNames.lawyerSignupScreen);
                },
            ),
          ],
        ),
      ),
    );
  }
}
