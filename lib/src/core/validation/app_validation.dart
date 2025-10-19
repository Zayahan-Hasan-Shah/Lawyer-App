class AppValidation {
  static String? checkText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be Empty';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number can't be empty";
    }
    final phone = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return "Phone number must contain only digits";
    }
    if (phone.startsWith('03')) {
      if (phone.length != 11) {
        return "Phone number should be 11 digits when starting with 03";
      }
    } else if (phone.startsWith('92')) {
      if (phone.length != 12) {
        return "Phone number should be 12 digits when starting with 92";
      }
    } else {
      return "Phone number must start with '03' or '92'";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email can't be empty";
    }
    final email = value.trim();
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return "Confirm password can't be empty";
    }
    if (password != confirmPassword) {
      return "Passwords do not match";
    }
    return null;
  }
}
