import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:architecto/routes/app_pages.dart';
import 'package:animate_do/animate_do.dart';
import 'package:architecto/presentation/controllers/login_controller.dart';
import 'package:architecto/config/theme_config.dart';

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
          padding: EdgeInsets.all(ThemeConfig.spacingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInRight(
                delay: const Duration(milliseconds: 150),
                child: Text(
                  "Let's sign you in.",
                  style: ThemeConfig.textHeadingLarge(context),
                ),
              ),
              FadeInRight(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  "Welcome back!",
                  style: ThemeConfig.textHeadingMedium(context),
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
                              prefix: Padding(
                                padding: EdgeInsets.only(
                                    left: ThemeConfig.spacingSmall + 4),
                                child: Icon(
                                  CupertinoIcons.mail,
                                  color:
                                      ThemeConfig.textSecondaryColor(context),
                                ),
                              ),
                              padding:
                                  EdgeInsets.all(ThemeConfig.spacingMedium),
                              decoration: BoxDecoration(
                                color:
                                    ThemeConfig.backgroundInputColor(context),
                                border: hasError
                                    ? Border.all(
                                        color: ThemeConfig.accentErrorColor(
                                                context)
                                            .withAlpha(179),
                                        width: ThemeConfig.borderWidth)
                                    : null,
                                borderRadius: ThemeConfig.radiusInput,
                              ),
                            ),
                            if (hasError)
                              Padding(
                                padding: EdgeInsets.only(top: 6, left: 4),
                                child: Text(
                                  controller.emailError.value!,
                                  style: ThemeConfig.textError(context),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(height: ThemeConfig.spacingMedium),
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
                              prefix: Padding(
                                padding: EdgeInsets.only(
                                    left: ThemeConfig.spacingSmall + 4),
                                child: Icon(
                                  CupertinoIcons.lock,
                                  color:
                                      ThemeConfig.textSecondaryColor(context),
                                ),
                              ),
                              suffix: Padding(
                                padding: EdgeInsets.only(
                                    right: ThemeConfig.spacingSmall + 4),
                                child: GestureDetector(
                                  onTap: controller.togglePasswordVisibility,
                                  child: Icon(
                                    controller.showPassword.value
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash,
                                    color:
                                        ThemeConfig.textSecondaryColor(context),
                                  ),
                                ),
                              ),
                              padding:
                                  EdgeInsets.all(ThemeConfig.spacingMedium),
                              decoration: BoxDecoration(
                                color:
                                    ThemeConfig.backgroundInputColor(context),
                                border: hasError
                                    ? Border.all(
                                        color: ThemeConfig.accentErrorColor(
                                                context)
                                            .withAlpha(179),
                                        width: ThemeConfig.borderWidth)
                                    : null,
                                borderRadius: ThemeConfig.radiusInput,
                              ),
                            ),
                            if (hasError)
                              Padding(
                                padding: EdgeInsets.only(top: 6, left: 4),
                                child: Text(
                                  controller.passwordError.value!,
                                  style: ThemeConfig.textError(context),
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
                  child: Obx(
                    () => CupertinoButton.filled(
                      padding: EdgeInsets.symmetric(
                          vertical: ThemeConfig.spacingMedium),
                      borderRadius: ThemeConfig.radiusButton,
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.login();
                            },
                      child: controller.isLoading.value
                          ? CupertinoActivityIndicator(
                              color: ThemeConfig.loaderOnPrimaryColor())
                          : Text(
                              'Sign In',
                              style: ThemeConfig.textButton(context),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInRight(
                delay: const Duration(milliseconds: 400),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: ThemeConfig.textSecondaryColor(context),
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
