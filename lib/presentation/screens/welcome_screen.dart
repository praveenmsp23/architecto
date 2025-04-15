import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:architecto/routes/app_pages.dart';
import 'package:architecto/services/auth/auth_service.dart';
import 'package:architecto/config/app_config.dart';
import 'package:architecto/config/theme_config.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    if (_authService.isLoggedIn) {
      await _authService.fetchUser();
      Get.offAllNamed(Routes.HOME);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CupertinoPageScaffold(
        child: Center(
          child: CupertinoActivityIndicator(radius: 20),
        ),
      );
    }

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            // Content area (image and text)
            Padding(
              padding: EdgeInsets.all(ThemeConfig.spacingMedium + 4),
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: FadeIn(
                      duration: const Duration(seconds: 1),
                      child: Lottie.asset(
                        'assets/lottie/buildings.json',
                        fit: BoxFit.contain,
                        repeat: false,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: ThemeConfig.spacingMedium),
                            child: Text(
                              AppConfig.instance.appName.toUpperCase(),
                              style: ThemeConfig.textHeadingLarge(context)
                                  .copyWith(
                                letterSpacing: 2,
                                fontSize: 36,
                              ),
                            ),
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: Text(
                            "Your all-in-one solution for construction project management - track labor attendance, manage site inventory, and maintain essential project details.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ThemeConfig.textSecondaryColor(context),
                              height: 1.25,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacer for the button area
                  SizedBox(height: 80),
                ],
              ),
            ),

            // Fixed button at bottom
            Positioned(
              left: ThemeConfig.spacingMedium + 4,
              right: ThemeConfig.spacingMedium + 4,
              bottom: ThemeConfig.spacingMedium + 4,
              child: FadeInUp(
                delay: const Duration(milliseconds: 1000),
                child: CupertinoButton.filled(
                  padding:
                      EdgeInsets.symmetric(vertical: ThemeConfig.spacingMedium),
                  borderRadius: ThemeConfig.radiusButton,
                  child: Text(
                    "GET STARTED",
                    style: ThemeConfig.textButton(context),
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.LOGIN);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}