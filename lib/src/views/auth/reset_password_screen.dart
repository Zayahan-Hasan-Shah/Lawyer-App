import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/validation/app_validation.dart';
import 'package:lawyer_app/src/providers/client_provider/auth_provider/reset_password.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/client_states/auth_states/reset_password_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_dialog.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final password = _passwordController.text.trim();

      try {
        final response = await ref
            .read(resetPasswordProvider.notifier)
            .resetPassword(password);

        if (response.isNotEmpty) {
          // ✅ Show success dialog
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CustomDialog(
                title: "Successfully!",
                description: "Password updated successfully.",
                buttonText: "OK",
                icon: Icons.check,
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  context.go(RouteNames.loginScreen); // go to login
                },
              ),
            );
          }
          log("ResetPasswordScreen → ResetPassword response: $response");
        }
        // ⚠️ Show error dialog (moved inside else)
        else {
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CustomDialog(
                title: "Error!",
                description: "Password update failed.",
                buttonText: "OK",
                icon: Icons.error_outline,
                onPressed: () => Navigator.of(context).pop(),
              ),
            );
          }
        }
      } catch (e, st) {
        log("ResetPasswordScreen → Exception during ResetPassword: $e\n$st");
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
                  title: "Reset Password!",
                  fontSize: 24.sp,
                  color: AppColors.whiteColor,
                  weight: FontWeight.bold,
                ),
                SizedBox(height: 2.h),
                _builPasswordTextField(),
                SizedBox(height: 1.5.h),
                _builConfirmPasswordTextField(),
                SizedBox(height: 2.h),
                _buildResetPasswordButton(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _builConfirmPasswordTextField() {
    return CustomTextField(
      controller: _confirmPasswordController,
      hintText: "Password",
      validator:(value) => AppValidation.validateConfirmPassword(
      _passwordController.text,
      value,
    ),
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
      prefixIcon: Icon(Icons.lock, color: AppColors.iconColor, size: 20),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
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

  Widget _buildResetPasswordButton() {
    final signupState = ref.watch(resetPasswordProvider);
    return SizedBox(
      width: double.infinity,
      height: 14.w,
      child: signupState is ResetPasswordStateLoading
          ? const Center(child: LoadingIndicator())
          : CustomButton(
              text: 'Signup',
              fontSize: 16.sp,
              onPressed: _resetPassword,
              textColor: AppColors.blackColor,
              gradient: AppColors.buttonGradientColor,
              fontWeight: FontWeight.w600,
              borderRadius: 30,
            ),
    );
  }
}
