import '../models/result.dart';

Result<String> checkPasswordStrength(String password) {
  if (password.isEmpty) {
    return Result(success: false, message: 'Please enter a password');
  } else if (password.length < 8) {
    return Result(success: false, message: 'Password is too short');
  } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return Result(success: false, message: 'Use at least one uppercase letter');
  } else if (!RegExp(r'[a-z]').hasMatch(password)) {
    return Result(success: false, message: 'Use at least one lowercase letter');
  } else if (!RegExp(r'[0-9]').hasMatch(password)) {
    return Result(success: false, message: 'Use at least one number');
  } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
    return Result(success: false, message: 'Use at least one special character');
  } else {
    return Result(success: true, message: '', data: password);
  }
}
