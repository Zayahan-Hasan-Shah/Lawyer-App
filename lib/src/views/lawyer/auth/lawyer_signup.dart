import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/validation/app_validation.dart';
import 'package:lawyer_app/src/providers/lawyer_provider/lawyer_auth_provider/lawyer_signup_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/lawyer_states/lawyer_auth_state/lawyer_signup_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_dialog.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_dropdown.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class LawyerSignup extends ConsumerStatefulWidget {
  const LawyerSignup({super.key});

  @override
  ConsumerState<LawyerSignup> createState() => _LawyerSignupState();
}

class _LawyerSignupState extends ConsumerState<LawyerSignup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _barCouncilNumberController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _yearOfEnrollmentController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _selectedCourt;
  String? _selectedCategory;

  final List<Map<String, String>> lawyerCategories = [
    {"court": "Supreme Court", "category": "Platinum"},
    {"court": "High Court", "category": "Gold"},
    {"court": "City Court", "category": "Silver"},
    {"court": "Student", "category": "Bronze"},
    {"court": "Law Firm", "category": "Green Card"},
  ];

  late final List<String> courtNames = lawyerCategories
      .map((item) => item["court"] as String)
      .toList();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _barCouncilNumberController.dispose();
    _phoneNumberController.dispose();
    _yearOfEnrollmentController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ref.listenManual<LawyerSignupState>(lawyerSignupProvider, (prev, next) {
      if (next is LawyerSignupSuccess) {
        _showSuccessDialog(next.message);
      } else if (next is LawyerSignupFailure) {
        _showErrorDialog("Signup Failed", next.error);
      }
    });
  }

  void _showSuccessDialog(String message) {
    _fullNameController.clear();
    _emailController.clear();
    _barCouncilNumberController.clear();
    _phoneNumberController.clear();
    _yearOfEnrollmentController.clear();
    _passwordController.clear();
    _selectedCategory = '';
    _selectedCourt = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomDialog(
        title: "Success",
        description: message,
        buttonText: "Continue",
        icon: Icons.check_circle,
        onPressed: () {
          Navigator.of(context).pop();
        },
        buttonGradient: const [Color(0xFF00FF7F), Color(0xFF006400)],
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

  Future<void> _lawyerSignup() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final barCouncilNo = _barCouncilNumberController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final yearOfEnroll = _yearOfEnrollmentController.text.trim();
    final password = _passwordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        barCouncilNo.isEmpty ||
        phoneNumber.isEmpty ||
        yearOfEnroll.isEmpty ||
        password.isEmpty ||
        _selectedCategory == null) {
      _showErrorDialog("Validation Error", "All fields are required.");
      return;
    }

    await ref
        .read(lawyerSignupProvider.notifier)
        .lawyerSignUp(
          fullName: fullName,
          email: email,
          barCouncilNo: barCouncilNo,
          phoneNumber: phoneNumber,
          yearOfEnrollment: yearOfEnroll,
          password: password,
          category: _selectedCategory!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(1.h),
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
                SizedBox(height: 1.h),
                _buildFullNameController(),
                SizedBox(height: 1.h),
                _buildEmailController(),
                SizedBox(height: 1.h),
                _buildCategoryDropdown(),
                SizedBox(height: 1.h),
                _buildBarCouncilController(),
                SizedBox(height: 1.h),
                _buildPhoneNumber(),
                SizedBox(height: 1.h),
                _buildYearOfEnroController(),
                SizedBox(height: 1.h),
                _buildPasswordController(),
                SizedBox(height: 1.h),
                _buildLawyerSignupButton(),
                SizedBox(height: 1.h),
                _loginTagLine(),
                SizedBox(height: 2.h),
                _buildBackButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameController() {
    return CustomTextField(
      controller: _fullNameController,
      validator: AppValidation.checkText,
      keyboardType: TextInputType.name,
      hintText: "Full Name",
      prefixIcon: Icon(Icons.person, color: AppColors.iconColor, size: 20),
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
    );
  }

  Widget _buildEmailController() {
    return CustomTextField(
      controller: _emailController,
      validator: AppValidation.validateEmail,
      keyboardType: TextInputType.emailAddress,
      hintText: "Email",
      prefixIcon: Icon(Icons.mail, color: AppColors.iconColor, size: 20),
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
    );
  }

  Widget _buildBarCouncilController() {
    return CustomTextField(
      controller: _barCouncilNumberController,
      validator: AppValidation.checkText,
      keyboardType: TextInputType.number,
      hintText: "Bar Council Number",
      prefixIcon: Icon(
        Icons.qr_code_scanner,
        color: AppColors.iconColor,
        size: 20,
      ),
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
    );
  }

  Widget _buildPhoneNumber() {
    return CustomTextField(
      controller: _phoneNumberController,
      validator: AppValidation.validatePhoneNumber,
      keyboardType: TextInputType.phone,
      hintText: "Phone Number",
      prefixIcon: Icon(Icons.phone, color: AppColors.iconColor, size: 20),
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
    );
  }

  Widget _buildYearOfEnroController() {
    return CustomTextField(
      controller: _yearOfEnrollmentController,
      validator: AppValidation.checkText,
      keyboardType: TextInputType.number,
      hintText: "Year Of Enrollment",
      prefixIcon: Icon(Icons.numbers, color: AppColors.iconColor, size: 20),
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
    );
  }

  Widget _buildPasswordController() {
    return CustomTextField(
      controller: _passwordController,
      validator: AppValidation.checkText,
      keyboardType: TextInputType.text,
      hintText: "Password",
      prefixIcon: Icon(Icons.lock, color: AppColors.iconColor, size: 20),
      textColor: AppColors.whiteColor,
      hintTextColor: AppColors.hintTextColor,
      obscureText: _obscurePassword,
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

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown(
          items: courtNames,
          selectedItem: _selectedCourt ?? "Select Court",
          onChanged: (String selectedCourt) {
            setState(() {
              _selectedCourt = selectedCourt;
              // Find corresponding category
              final selectedItem = lawyerCategories.firstWhere(
                (item) => item["court"] == selectedCourt,
              );
              _selectedCategory = selectedItem["category"];
            });
          },
        ),
        if (_selectedCourt == null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              "Please select your court",
              style: TextStyle(color: Colors.red.shade300, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }

  Widget _buildLawyerSignupButton() {
    final lawyerSignupState = ref.watch(lawyerSignupProvider);
    return SizedBox(
      width: double.infinity,
      height: 14.w,
      child: lawyerSignupState is LawyerSignupLoading
          ? const Center(child: LoadingIndicator())
          : CustomButton(
              text: 'Signup',
              fontSize: 16.sp,
              onPressed: _lawyerSignup,
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
                  context.go(RouteNames.lawyerloginScreen);
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
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
    );
  }
}
