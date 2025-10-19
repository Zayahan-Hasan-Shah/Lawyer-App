import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/validation/app_validation.dart';
import 'package:lawyer_app/src/providers/auth_provider/signup_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/auth_states/signup_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_dialog.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final password = _passwordController.text.trim();
      final address = _addressController.text.trim();
      try {
        final response = await ref
            .read(signupProvider.notifier)
            .signup(
              name: name,
              email: email,
              phoneNumber: phoneNumber,
              password: password,
              address: address,
            );
        if (response != null) {
          log("SignupScreen → Signup response: $response");
          showDialog(
            context: context,
            builder: (_) => CustomDialog(
              title: "Success",
              description: response,
              buttonText: "Continue",
              icon: Icons.check_circle,
              onPressed: () {
                Navigator.pop(context);
                context.go(RouteNames.loginScreen);
              },
              buttonGradient: const [Color(0xFF00FF7F), Color(0xFF006400)],
            ),
          );
        }
        log("SignupScreen → Signup failed, response is null");
        _showErrorDialog(
          "Signup Failed",
          "Invalid signup details. Please try again.",
        );
      } catch (e, st) {
        log("SignupScreen → Exception during Signup: $e\n$st");
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
                  title: "Sign Up",
                  fontSize: 24.sp,
                  color: AppColors.whiteColor,
                  weight: FontWeight.bold,
                ),
                SizedBox(height: 2.h),
                _builNameTextField(),
                SizedBox(height: 1.5.h),
                _builPhoneNumberTextField(),
                SizedBox(height: 1.5.h),
                _builEmailTextField(),
                SizedBox(height: 1.5.h),
                _builPasswordTextField(),
                SizedBox(height: 1.5.h),
                _builAddressTextField(),
                SizedBox(height: 2.h),
                _buildSignupButton(),
                SizedBox(height: 1.h),
                _loginTagLine(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _builNameTextField() {
    return CustomTextField(
      controller: _nameController,
      hintText: "Full Name",
      validator: AppValidation.checkText,
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
      prefixIcon: Icon(Icons.person, color: AppColors.iconColor, size: 20),
    );
  }

  Widget _builPhoneNumberTextField() {
    return CustomTextField(
      controller: _phoneNumberController,
      hintText: "Phone Number",
      validator: AppValidation.validatePhoneNumber,
      keyboardType: TextInputType.phone,
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
      prefixIcon: Icon(Icons.phone, color: AppColors.iconColor, size: 20),
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

  Widget _builAddressTextField() {
    return CustomTextField(
      controller: _addressController,
      hintText: "Address",
      validator: AppValidation.checkText,
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
      prefixIcon: Icon(
        Icons.location_history,
        color: AppColors.iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildSignupButton() {
    final signupState = ref.watch(signupProvider);
    return SizedBox(
      width: double.infinity,
      height: 14.w,
      child: signupState is SignupLoading
          ? const Center(child: LoadingIndicator())
          : CustomButton(
              text: 'Signup',
              fontSize: 16.sp,
              onPressed: _signup,
              textColor: AppColors.blackColor,
              gradient: AppColors.buttonGradientColor,
              fontWeight: FontWeight.w600,
              borderRadius: 30,
            ),
    );
  }

  Widget _loginTagLine() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Already have an account?",
          style: TextStyle(color: AppColors.hintTextColor, fontSize: 16.sp),
          children: [
            TextSpan(
              text: ' Sign In',
              style: TextStyle(color: AppColors.iconColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.go(RouteNames.loginScreen);
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
