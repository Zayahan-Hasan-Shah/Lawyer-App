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

  late final ProviderSubscription<LawyerSignupState> _signupListener;

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
    _signupListener.close();
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
    _signupListener =
        ref.listenManual<LawyerSignupState>(lawyerSignupProvider, (prev, next) {
      if (next is LawyerSignupSuccess) {
        _showSuccessDialog(next.message);
        context.go(RouteNames.lawyerloginScreen);
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
    final isLoading = ref.watch(lawyerSignupProvider) is LawyerSignupLoading;

    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo + Title
                Center(
                  child: Row(
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
                            title: "Lawyer\nRegistration",
                            color: AppColors.kTextPrimary,
                            fontSize: 20.sp,
                            weight: FontWeight.w800,
                            maxLines: 2,
                          ),
                          // SizedBox(height: 0.4.h),
                          CustomText(
                            title: "Join the professional\nlegal network",
                            color: AppColors.kTextSecondary,
                            fontSize: 16.sp,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                // Fields with better spacing
                _buildField(
                  "Full Name",
                  _fullNameController,
                  Icons.person,
                  AppValidation.checkText,
                ),
                SizedBox(height: 2.h),
                _buildField(
                  "Email Address",
                  _emailController,
                  Icons.mail,
                  AppValidation.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 2.h),
                _buildCategoryDropdown(),
                SizedBox(height: 2.h),
                _buildField(
                  "Bar Council Number",
                  _barCouncilNumberController,
                  Icons.qr_code_scanner,
                  AppValidation.checkText,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 2.h),
                _buildField(
                  "Phone Number",
                  _phoneNumberController,
                  Icons.phone,
                  AppValidation.validatePhoneNumber,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 2.h),
                _buildField(
                  "Year of Enrollment",
                  _yearOfEnrollmentController,
                  Icons.calendar_today,
                  AppValidation.checkText,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 2.h),
                _buildPasswordField(),
                SizedBox(height: 3.h),
                // Button
                _buildLawyerSignupButton(isLoading),
                SizedBox(height: 1.5.h),
                // Login link
                Center(child: _loginTagLine()),
                SizedBox(height: 2.h),
                // Back
                Center(child: _buildBackButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String hint,
    TextEditingController controller,
    IconData icon,
    String? Function(String?)? validator, {
    TextInputType? keyboardType,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.kEmerald, size: 22),
      validator: validator,
      keyboardType: keyboardType,
      textColor: AppColors.kTextPrimary,
      hintTextColor: AppColors.kTextSecondary,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      hintText: "Create Password",
      prefixIcon: Icon(Icons.lock, color: AppColors.kEmerald, size: 22),
      obscureText: _obscurePassword,
      validator: AppValidation.checkText,
      textColor: AppColors.kTextPrimary,
      hintTextColor: AppColors.kTextSecondary,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: AppColors.kEmerald.withOpacity(0.8),
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown(
          items: courtNames,
          selectedItem: _selectedCourt,
          hint: "Select Court",
          onChanged: (String selectedCourt) {
            setState(() {
              _selectedCourt = selectedCourt;
              final selectedItem = lawyerCategories.firstWhere(
                (item) => item["court"] == selectedCourt,
              );
              _selectedCategory = selectedItem["category"];
            });
          },
        ),
        if (_selectedCourt == null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 6),
            child: Text(
              "Please select your court",
              style: TextStyle(
                color: Colors.redAccent.withOpacity(0.9),
                fontSize: 14.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLawyerSignupButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isLoading
          ? Center(child: LoadingIndicator(color: AppColors.kEmerald))
          : CustomButton(
              text: 'Create Lawyer Account',
              onPressed: _lawyerSignup,
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

  // Keep your _loginTagLine and _buildBackButton, just update colors
  Widget _loginTagLine() {
    return RichText(
      text: TextSpan(
        text: "Already registered? ",
        style: TextStyle(color: AppColors.kTextSecondary, fontSize: 15.sp),
        children: [
          TextSpan(
            text: 'Sign In',
            style: TextStyle(
              color: AppColors.kEmerald,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.go(RouteNames.lawyerloginScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return TextButton(
      onPressed: () => context.go(RouteNames.incomingUserScreen),
      child: Text(
        '← Back to Role Selection',
        style: TextStyle(color: AppColors.kTextSecondary, fontSize: 14.sp),
      ),
    );
  }
}
