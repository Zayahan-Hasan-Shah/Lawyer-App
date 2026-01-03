import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/src/core/validation/app_validation.dart';
import 'package:lawyer_app/src/providers/client_provider/auth_provider/forgot_password_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/client_states/auth_states/forogot_password_State.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final StorageService _storageService = StorageService.instance;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _forgotPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      try {
        final response = await ref
            .read(forgotPasswordProvider.notifier)
            .forgotPassword(email: email);
        if (response != null) {
          log("ForgotPasswordScreen → ForgotPassword response: $response");
          await _storageService.saveForgotEmail(email);
          log("Saving forgot email: $email");
          context.pushNamed(RouteNames.otpScreen);
        }
        log("ForgotPasswordScreen → ForgotPassword failed, response is null");
      } catch (e, st) {
        log("ForgotPasswordScreen → Exception during ForgotPassword: $e\n$st");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppbar(title: '', isBack: true),
      ),
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
                  title: "Forgot Password!",
                  fontSize: 24.sp,
                  color: AppColors.whiteColor,
                  weight: FontWeight.bold,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  title: "Enter email address to get a verification code",
                  fontSize: 15.sp,
                  color: AppColors.lightDescriptionTextColor,
                  weight: FontWeight.bold,
                ),
                SizedBox(height: 2.h),
                _builEmailTextField(),
                SizedBox(height: 2.h),
                _buildSignupButton(),
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

  Widget _buildSignupButton() {
    final forgotState = ref.watch(forgotPasswordProvider);
    return SizedBox(
      width: double.infinity,
      height: 14.w,
      child: forgotState is ForgotPasswordLoading
          ? const Center(child: LoadingIndicator())
          : CustomButton(
              text: 'Continue',
              fontSize: 16.sp,
              onPressed: _forgotPassword,
              textColor: AppColors.blackColor,
              gradient: AppColors.buttonGradientColor,
              fontWeight: FontWeight.w600,
              borderRadius: 30,
            ),
    );
  }
}
