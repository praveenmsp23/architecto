import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:architecto/routes/app_pages.dart';
import 'package:animate_do/animate_do.dart';
import 'package:architecto/presentation/controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());

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
                  "Let's sign you in.",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              
              FadeInRight(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontSize: 20,
                    color: CupertinoColors.systemGrey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    FadeInRight(
                      delay: const Duration(milliseconds: 250),
                      child: Obx(() {
                        final hasError = controller.emailError.value != null;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CupertinoTextField(
                              controller: controller.emailController,
                              placeholder: "Email",
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) => controller.clearErrors(),
                              onSubmitted: (_) => controller.validateFields(),
                              prefix: const Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Icon(
                                  CupertinoIcons.mail,
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
                                  controller.emailError.value!,
                                  style: const TextStyle(
                                    color: CupertinoColors.systemRed,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    FadeInRight(
                      delay: const Duration(milliseconds: 300),
                      child: Obx(() {
                        final hasError = controller.passwordError.value != null;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CupertinoTextField(
                              controller: controller.passwordController,
                              placeholder: "Password",
                              obscureText: !controller.showPassword.value,
                              onChanged: (_) => controller.clearErrors(),
                              onSubmitted: (_) => controller.validateFields(),
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
                                  onTap: controller.togglePasswordVisibility,
                                  child: Icon(
                                    controller.showPassword.value
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
                                  controller.passwordError.value!,
                                  style: const TextStyle(
                                    color: CupertinoColors.systemRed,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              FadeInRight(
                delay: const Duration(milliseconds: 350),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() => CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onPressed: controller.isLoading.value ? null : () {
                      controller.login();
                    },
                    child: controller.isLoading.value
                        ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                        : const Text(
                            'Sign In',
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
                delay: const Duration(milliseconds: 400),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Get.toNamed(Routes.REGISTER),
                      child: const Text('Sign Up'),
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
}