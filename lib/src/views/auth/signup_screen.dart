import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/validation/app_validation.dart';
import 'package:lawyer_app/src/providers/client_provider/auth_provider/signup_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/client_states/auth_states/signup_state.dart';
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

  @override
  void initState() {
    super.initState();
    ref.listenManual<SignupState>(signupProvider, (prev, next) {
      if (next is SignupSuccess) {
        _showSuccessDialog(next.message);
      } else if (next is SignupFailure) {
        _showErrorDialog("Signup Failed", next.error);
      }
    });
  }

  void _showSuccessDialog(String message) {
    _nameController.clear();
    _emailController.clear();
    _phoneNumberController.clear();
    _passwordController.clear();
    _addressController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomDialog(
        title: "Account Created",
        description: message,
        buttonText: "Continue to Login",
        icon: Icons.check_circle_outline_rounded,
        onPressed: () {
          Navigator.pop(context);
          context.go(RouteNames.loginScreen);
        },
        buttonGradient: const [Color(0xFF10B981), Color(0xFF059669)],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title,
        description: message,
        buttonText: "Try Again",
        icon: Icons.error_outline_rounded,
        buttonGradient: const [Color(0xFFFF6B6B), Color(0xFFC0392B)],
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _signup() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneNumberController.text.trim();
    final password = _passwordController.text.trim();
    final address = _addressController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        address.isEmpty) {
      _showErrorDialog("Validation Error", "Please fill all required fields.");
      return;
    }

    await ref
        .read(signupProvider.notifier)
        .signup(
          fullName: fullName,
          email: email,
          phone: phone,
          password: password,
          address: address,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signupProvider) is SignupLoading;

    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo + Welcome Header
                Row(
                  children: [
                    Container(
                      height: 14.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kEmerald.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppAssets.logoImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: "Create Your\nAccount",
                          color: AppColors.kTextPrimary,
                          fontSize: 20.sp,
                          maxLines: 2,
                          weight: FontWeight.w800,
                        ),
                        CustomText(
                          title: "Join our legal\nplatform in seconds",
                          color: AppColors.kTextSecondary,
                          fontSize: 16.sp,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
      
                // Form Fields (glassmorphic style - assume CustomTextField updated)
                CustomTextField(
                  controller: _nameController,
                  hintText: "Full Name",
                  validator: AppValidation.validateFullName,
                  prefixIcon: Icon(
                    Icons.person_rounded,
                    color: AppColors.kEmerald,
                    size: 24,
                  ),
                  textColor: AppColors.kTextPrimary,
                  hintTextColor: AppColors.kTextSecondary,
                ),
                SizedBox(height: 2.2.h),
      
                CustomTextField(
                  controller: _phoneNumberController,
                  hintText: "Phone Number",
                  validator: AppValidation.validatePhoneNumber,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    Icons.phone_rounded,
                    color: AppColors.kEmerald,
                    size: 24,
                  ),
                  textColor: AppColors.kTextPrimary,
                  hintTextColor: AppColors.kTextSecondary,
                ),
                SizedBox(height: 2.2.h),
      
                CustomTextField(
                  controller: _emailController,
                  hintText: "Email Address",
                  validator: AppValidation.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email_rounded,
                    color: AppColors.kEmerald,
                    size: 24,
                  ),
                  textColor: AppColors.kTextPrimary,
                  hintTextColor: AppColors.kTextSecondary,
                ),
                SizedBox(height: 2.2.h),
      
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Create Password",
                  obscureText: _obscurePassword,
                  validator: AppValidation.checkText,
                  prefixIcon: Icon(
                    Icons.lock_rounded,
                    color: AppColors.kEmerald,
                    size: 24,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.kEmerald.withOpacity(0.8),
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  textColor: AppColors.kTextPrimary,
                  hintTextColor: AppColors.kTextSecondary,
                ),
                SizedBox(height: 2.2.h),
      
                CustomTextField(
                  controller: _addressController,
                  hintText: "Address",
                  validator: AppValidation.checkText,
                  prefixIcon: Icon(
                    Icons.location_on_rounded,
                    color: AppColors.kEmerald,
                    size: 24,
                  ),
                  textColor: AppColors.kTextPrimary,
                  hintTextColor: AppColors.kTextSecondary,
                ),
      
                SizedBox(height: 4.5.h),
      
                // Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: isLoading
                      ? const Center(
                          child: LoadingIndicator(color: AppColors.kEmerald),
                        )
                      : CustomButton(
                          text: 'Create Account',
                          onPressed: _signup,
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
      
                SizedBox(height: 3.5.h),
      
                // Login Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        color: AppColors.kTextSecondary,
                        fontSize: 15.sp,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: AppColors.kEmerald,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                context.go(RouteNames.loginScreen),
                        ),
                      ],
                    ),
                  ),
                ),
      
                SizedBox(height: 4.h),
      
                // Back to role selection
                Center(
                  child: TextButton(
                    onPressed: () =>
                        context.go(RouteNames.incomingUserScreen),
                    child: Text(
                      '← Back to Role Selection',
                      style: TextStyle(
                        color: AppColors.kTextSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
      
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
