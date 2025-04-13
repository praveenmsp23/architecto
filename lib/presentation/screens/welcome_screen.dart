import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:architecto/routes/app_pages.dart';
import 'package:architecto/services/auth/auth_service.dart';
import 'package:architecto/config/app_config.dart';
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
              padding: const EdgeInsets.all(20),
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
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              AppConfig.instance.appName.toUpperCase(),
                              style: TextStyle(
                                fontSize: 36,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w800,
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
                              color: CupertinoColors.systemGrey,
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
              left: 20,
              right: 20,
              bottom: 20,
              child: FadeInUp(
                delay: const Duration(milliseconds: 1000),
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  borderRadius: BorderRadius.circular(8),
                  child: Text("GET STARTED"),
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