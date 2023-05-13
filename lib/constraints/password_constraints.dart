String passwordPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
RegExp regExp = RegExp(passwordPattern);

String validatePassword(String value) {
  if (value.isEmpty) {
    return 'Please enter your password.';
  } else if (!regExp.hasMatch(value)) {
    return 'Your password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.';
  }
  return "";
}
