import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/src/providers/auth_provider/forgot_password_provider.dart';
import 'package:lawyer_app/src/providers/auth_provider/otp_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/auth_states/otp_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _pin = '';

  Future<void> _verifyOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await ref.read(otpProvider.notifier).verifyOtp(_pin);
        if (response != null) {
          log("OTPScreen → OTP response: $response");
          context.pushNamed(RouteNames.loginScreen);
        }
        log("OTPScreen → OTP responsefailed, response is null");
      } catch (e, st) {
        log("OTPScreen → Exception during OTP: $e\n$st");
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
                  title: "OTP!",
                  fontSize: 24.sp,
                  color: AppColors.whiteColor,
                  weight: FontWeight.bold,
                ),
                SizedBox(height: 2.h),
                _buildOtpField(),
                SizedBox(height: 4.h),
                _buildSignupButton(),
                SizedBox(height: 9.h),
                _buildResendOtpText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField() {
    return PinCodeTextField(
      enableActiveFill: true,
      appContext: context,
      length: 6,
      keyboardType: TextInputType.number,
      cursorColor: AppColors.iconColor,
      obscureText: false,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.iconColor,
      ),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: 55,
        fieldWidth: 55,
        activeColor: AppColors.iconColor,
        inactiveColor: AppColors.pastelYellowColor,
        selectedColor: AppColors.yellowColor,
        activeFillColor: AppColors.inputBackgroundColor,
        inactiveFillColor: AppColors.inputBackgroundColor,
        selectedFillColor: AppColors.inputBackgroundColor,
        borderWidth: 2,
      ),
      animationType: AnimationType.scale,
      animationDuration: const Duration(milliseconds: 250),
      onChanged: (value) => _pin = value,
      onCompleted: (val) {},
    );
  }

  Widget _buildSignupButton() {
    final loginState = ref.watch(otpProvider);
    return SizedBox(
      width: double.infinity,
      height: 14.w,
      child: loginState is OtpStateLoading
          ? const Center(child: LoadingIndicator())
          : CustomButton(
              text: 'Continue',
              fontSize: 16.sp,
              onPressed: _verifyOtp,
              textColor: AppColors.blackColor,
              gradient: AppColors.buttonGradientColor,
              fontWeight: FontWeight.w600,
              borderRadius: 30,
            ),
    );
  }

  Widget _buildResendOtpText() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't receice code?",
          style: TextStyle(color: AppColors.hintTextColor, fontSize: 16.sp),
          children: [
            TextSpan(
              text: ' Resend',
              style: TextStyle(color: AppColors.iconColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final email = await StorageService.instance.getForgotEmail();
                  log("Resend OTP tapped.");
                  ref
                      .read(forgotPasswordProvider.notifier)
                      .forgotPassword(email: email!);
                },
            ),
          ],
        ),
      ),
    );
  }
}
