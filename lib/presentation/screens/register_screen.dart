import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:architecto/presentation/controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInRight(
                delay: const Duration(milliseconds: 150),
                child: const Text(
                  "Create an account.",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              
              FadeInRight(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  "Join us today!",
                  style: TextStyle(
                    fontSize: 20,
                    color: CupertinoColors.systemGrey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: controller.nameController,
                          placeholder: "Name",
                          prefix: CupertinoIcons.person,
                          keyboardType: TextInputType.name,
                          error: controller.nameError,
                          delay: 225,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: controller.emailController,
                          placeholder: "Email",
                          prefix: CupertinoIcons.mail,
                          keyboardType: TextInputType.emailAddress,
                          error: controller.emailError,
                          delay: 250,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildPasswordField(
                          controller: controller.passwordController,
                          placeholder: "Password",
                          error: controller.passwordError,
                          showPassword: controller.showPassword,
                          toggleVisibility: controller.togglePasswordVisibility,
                          delay: 300,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildPasswordField(
                          controller: controller.confirmPasswordController,
                          placeholder: "Confirm Password",
                          error: controller.confirmPasswordError,
                          showPassword: controller.showConfirmPassword,
                          toggleVisibility: controller.toggleConfirmPasswordVisibility,
                          delay: 350,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: controller.phoneController,
                          placeholder: "Phone (optional)",
                          prefix: CupertinoIcons.phone,
                          keyboardType: TextInputType.phone,
                          error: controller.phoneError,
                          delay: 375,
                        ),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              
              FadeInRight(
                delay: const Duration(milliseconds: 400),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() => CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onPressed: controller.isLoading.value ? null : () {
                      controller.clearErrors();
                      controller.register();
                    },
                    child: controller.isLoading.value
                        ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  )),
                ),
              ),
              
              const SizedBox(height: 20),
              
              FadeInRight(
                delay: const Duration(milliseconds: 450),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Get.back(),
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    required IconData prefix,
    required TextInputType keyboardType,
    required Rx<String?> error,
    required int delay,
  }) {
    return FadeInRight(
      delay: Duration(milliseconds: delay),
      child: Obx(() {
        final hasError = error.value != null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoTextField(
              controller: controller,
              placeholder: placeholder,
              keyboardType: keyboardType,
              onChanged: (_) => this.controller.clearErrors(),
              prefix: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(
                  prefix,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                border: hasError 
                    ? Border.all(color: CupertinoColors.systemRed.withOpacity(0.7), width: 1.0)
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  error.value!,
                  style: const TextStyle(
                    color: CupertinoColors.systemRed,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
  
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String placeholder,
    required Rx<String?> error,
    required RxBool showPassword,
    required Function toggleVisibility,
    required int delay,
  }) {
    return FadeInRight(
      delay: Duration(milliseconds: delay),
      child: Obx(() {
        final hasError = error.value != null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoTextField(
              controller: controller,
              placeholder: placeholder,
              obscureText: !showPassword.value,
              onChanged: (_) => this.controller.clearErrors(),
              prefix: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  CupertinoIcons.lock,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              suffix: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => toggleVisibility(),
                  child: Icon(
                    showPassword.value
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                border: hasError 
                    ? Border.all(color: CupertinoColors.systemRed.withOpacity(0.7), width: 1.0)
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  error.value!,
                  style: const TextStyle(
                    color: CupertinoColors.systemRed,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
} 