import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:architecto/presentation/controllers/register_controller.dart';
import 'package:architecto/config/theme_config.dart';

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
          padding: EdgeInsets.all(ThemeConfig.spacingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInRight(
                delay: const Duration(milliseconds: 150),
                child: Text(
                  "Create an account.",
                  style: ThemeConfig.textHeadingLarge(context),
                ),
              ),
              FadeInRight(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  "Join us today!",
                  style: ThemeConfig.textHeadingMedium(context),
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
                        SizedBox(height: ThemeConfig.spacingMedium),
                        _buildTextField(
                          controller: controller.emailController,
                          placeholder: "Email",
                          prefix: CupertinoIcons.mail,
                          keyboardType: TextInputType.emailAddress,
                          error: controller.emailError,
                          delay: 250,
                        ),
                        SizedBox(height: ThemeConfig.spacingMedium),
                        _buildPasswordField(
                          controller: controller.passwordController,
                          placeholder: "Password",
                          error: controller.passwordError,
                          showPassword: controller.showPassword,
                          toggleVisibility: controller.togglePasswordVisibility,
                          delay: 300,
                        ),
                        SizedBox(height: ThemeConfig.spacingMedium),
                        _buildPasswordField(
                          controller: controller.confirmPasswordController,
                          placeholder: "Confirm Password",
                          error: controller.confirmPasswordError,
                          showPassword: controller.showConfirmPassword,
                          toggleVisibility:
                              controller.toggleConfirmPasswordVisibility,
                          delay: 350,
                        ),
                        SizedBox(height: ThemeConfig.spacingMedium),
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
                  child: Obx(
                    () => CupertinoButton.filled(
                      padding: EdgeInsets.symmetric(
                          vertical: ThemeConfig.spacingMedium),
                      borderRadius: ThemeConfig.radiusButton,
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.clearErrors();
                              controller.register();
                            },
                      child: controller.isLoading.value
                          ? CupertinoActivityIndicator(
                              color: ThemeConfig.loaderOnPrimaryColor())
                          : Text(
                              'Sign Up',
                              style: ThemeConfig.textButton(context),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInRight(
                delay: const Duration(milliseconds: 450),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: ThemeConfig.textSecondaryColor(context),
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
                padding: EdgeInsets.only(left: ThemeConfig.spacingSmall + 4),
                child: Icon(
                  prefix,
                  color: ThemeConfig.textSecondaryColor(context),
                ),
              ),
              padding: EdgeInsets.all(ThemeConfig.spacingMedium),
              decoration: BoxDecoration(
                color: ThemeConfig.backgroundInputColor(context),
                border: hasError
                    ? Border.all(
                        color: ThemeConfig.accentErrorColor(context)
                            .withAlpha(179),
                        width: ThemeConfig.borderWidth,
                      )
                    : null,
                borderRadius: ThemeConfig.radiusInput,
              ),
            ),
            if (hasError)
              Padding(
                padding: EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  error.value!,
                  style: ThemeConfig.textError(context),
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
              prefix: Padding(
                padding: EdgeInsets.only(left: ThemeConfig.spacingSmall + 4),
                child: Icon(
                  CupertinoIcons.lock,
                  color: ThemeConfig.textSecondaryColor(context),
                ),
              ),
              suffix: Padding(
                padding: EdgeInsets.only(right: ThemeConfig.spacingSmall + 4),
                child: GestureDetector(
                  onTap: () => toggleVisibility(),
                  child: Icon(
                    showPassword.value
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: ThemeConfig.textSecondaryColor(context),
                  ),
                ),
              ),
              padding: EdgeInsets.all(ThemeConfig.spacingMedium),
              decoration: BoxDecoration(
                color: ThemeConfig.backgroundInputColor(context),
                border: hasError
                    ? Border.all(
                        color: ThemeConfig.accentErrorColor(context)
                            .withAlpha(179),
                        width: ThemeConfig.borderWidth,
                      )
                    : null,
                borderRadius: ThemeConfig.radiusInput,
              ),
            ),
            if (hasError)
              Padding(
                padding: EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  error.value!,
                  style: ThemeConfig.textError(context),
                ),
              ),
          ],
        );
      }),
    );
  }
}
