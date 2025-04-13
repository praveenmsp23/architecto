import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:architecto/routes/app_pages.dart';
import 'package:architecto/services/auth/auth_service.dart';
import 'package:architecto/services/message/message_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxBool showPassword = false.obs;
  final Rx<String?> emailError = Rx<String?>(null);
  final Rx<String?> passwordError = Rx<String?>(null);
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }
  
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  
  void validateFields() {
    emailError.value = validateEmail(emailController.text);
    passwordError.value = validatePassword(passwordController.text);
  }
  
  void clearErrors() {
    emailError.value = null;
    passwordError.value = null;
  }
  
  Future<void> login() async {
    validateFields();
    
    if (emailError.value != null || passwordError.value != null) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      await _authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      isLoading.value = false;
      _handleAuthError(e);
    }
  }
  
  void _handleAuthError(dynamic error) {
    String message = 'An error occurred. Please try again.';
    
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        case 'invalid-credential':
          message = 'Invalid email or password. Please check your credentials.';
          break;
        default:
          message = error.message ?? message;
      }
    }
    
    Message.error(message);
  }
}