import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:architecto/routes/app_pages.dart';
import 'package:architecto/services/auth/auth_service.dart';
import 'package:architecto/services/message/message_service.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();
  
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxBool showPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;
  
  final Rx<String?> nameError = Rx<String?>(null);
  final Rx<String?> emailError = Rx<String?>(null);
  final Rx<String?> passwordError = Rx<String?>(null);
  final Rx<String?> confirmPasswordError = Rx<String?>(null);
  final Rx<String?> phoneError = Rx<String?>(null);
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
  
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }
  
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
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
  
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty && !GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
  
  void validateForm() {
    nameError.value = validateName(nameController.text);
    emailError.value = validateEmail(emailController.text);
    passwordError.value = validatePassword(passwordController.text);
    confirmPasswordError.value = validateConfirmPassword(confirmPasswordController.text);
    phoneError.value = validatePhone(phoneController.text);
  }
  
  void clearErrors() {
    nameError.value = null;
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
    phoneError.value = null;
  }
  
  Future<void> register() async {
    validateForm();
    
    if (nameError.value != null || 
        emailError.value != null || 
        passwordError.value != null || 
        confirmPasswordError.value != null || 
        phoneError.value != null) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      await _authService.registerWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        nameController.text,
        phoneController.text.isNotEmpty ? phoneController.text : null
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
        case 'email-already-in-use':
          message = 'The email address is already in use.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          message = 'The password is too weak.';
          break;
        case 'invalid-credential':
          message = 'Invalid credential provided. Please check your information.';
          break;
        default:
          message = error.message ?? message;
      }
    }
    
    Message.error(message);
  }
}