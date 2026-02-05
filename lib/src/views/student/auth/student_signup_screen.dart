import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/validation/app_validation.dart';
import 'package:lawyer_app/src/providers/student_provider/student_auth_provider/student_signup_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/student_states/student_auth_state/student_signup_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_dialog.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class StudentSignupScreen extends ConsumerStatefulWidget {
  const StudentSignupScreen({super.key});

  @override
  ConsumerState<StudentSignupScreen> createState() =>
      _StudentSignupScreenState();
}

class _StudentSignupScreenState extends ConsumerState<StudentSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fatherNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  void _showSuccesssDialog(String message) {
    _fatherNameController.clear();
    _fullNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _dobController.clear();
    _phoneController.clear();
    _addressController.clear();
    _universityController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CustomDialog(
        title: "Success",
        description: message,
        buttonText: "OK",
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

  Future<void> _studentSignup() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final fullName = _fullNameController.text.trim();
    final fatherName = _fatherNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final dob = _dobController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final university = _universityController.text.trim();
    if (fullName.isEmpty ||
        fatherName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        dob.isEmpty ||
        phoneNumber.isEmpty ||
        address.isEmpty ||
        university.isEmpty) {
      _showErrorDialog("Incomplete Information", "Please fill all the fields.");
      return;
    }

    await ref
        .read(studentSignupProvider.notifier)
        .studentSignupCont(
          fullName: fullName,
          fatherName: fatherName,
          dob: dob,
          phoneNumber: phoneNumber,
          university: university,
          address: address,
          password: password,
          email: email,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<StudentSignupState>(studentSignupProvider, (previous, next) {
      if (next is StudentSignupSuccess) {
        _showSuccesssDialog(next.message);
        // Optional: Navigate to another screen after success
        // Future.delayed(const Duration(seconds: 2), () {
        //   context.go(RouteNames.someScreen);
        // });
      } else if (next is StudentSignupFailure) {
        _showErrorDialog("Signup Failed", next.error);
      }
    });
    final isLoading = ref.watch(studentSignupProvider) is StudentSignupLoading;
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
                            title: "Student\nRegistration",
                            color: AppColors.kTextPrimary,
                            fontSize: 20.sp,
                            weight: FontWeight.w800,
                            maxLines: 2,
                          ),
                          SizedBox(height: 0.4.h),
                          CustomText(
                            title:
                                "Elevate your career\nYour Legal Journey\nStarts Here",
                            color: AppColors.kTextSecondary,
                            fontSize: 16.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                _buildForm(
                  "Full Name",
                  _fullNameController,
                  Icons.person,
                  AppValidation.validateFullName,
                ),
                SizedBox(height: 1.h),
                _buildForm(
                  "Date of Birth",
                  _dobController,
                  Icons.calendar_month,
                  AppValidation.checkText,
                ),
                SizedBox(height: 1.h),
                _buildForm(
                  "Father's Name",
                  _fatherNameController,
                  Icons.person,
                  AppValidation.validateFullName,
                ),
                SizedBox(height: 1.h),
                _buildForm(
                  "Email Address",
                  _emailController,
                  Icons.mail,
                  AppValidation.validateEmail,
                ),
                SizedBox(height: 1.h),
                _buildPasswordField(),
                SizedBox(height: 1.h),
                _buildForm(
                  "University/Institure",
                  _universityController,
                  Icons.account_balance_sharp,
                  AppValidation.checkText,
                ),
                SizedBox(height: 1.h),
                _buildForm(
                  "Phone Number",
                  _phoneController,
                  Icons.mail,
                  AppValidation.validatePhoneNumber,
                ),
                SizedBox(height: 1.h),
                _buildForm(
                  "Address",
                  _addressController,
                  Icons.mail,
                  AppValidation.checkText,
                ),
                SizedBox(height: 2.h),
                _buildStudentSignupButton(isLoading),
                SizedBox(height: 1.h),
                Center(child: _loginTagLine()),
                SizedBox(height: 2.h),
                Center(child: _buildBackButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(
    String hint,
    TextEditingController controller,
    IconData icon,
    String? Function(String?)? validator, {
    TextInputType? keyboardType,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.kEmerald, size: 3.h),
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

  Widget _buildStudentSignupButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isLoading
          ? Center(child: LoadingIndicator(color: AppColors.kEmerald))
          : CustomButton(
              text: 'Register',
              onPressed: _studentSignup,
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
              ..onTap = () => context.go(RouteNames.studentLoginScreen),
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
