import 'package:animate_do/animate_do.dart';
import 'package:architecto/config/config.dart';
import 'package:architecto/extensions/theme.dart';
import 'package:architecto/pages/auth/signin.dart';
import 'package:architecto/pages/auth/signup.dart';
import 'package:architecto/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeIn(
              duration: const Duration(seconds: 1),
              child: Lottie.asset(
                'assets/lottie/buildings.json',
                fit: BoxFit.fitWidth,
                repeat: false,
              ),
            ),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          Config.appName,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: Text(
                        "Architecto is a mobile app designed to manage labor attendance, track site stock, and maintain essential details for construction projects.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.secondaryTextColor,
                          height: 1.25,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    FadeInUp(
                      delay: const Duration(milliseconds: 1000),
                      child: Button(
                        variant: ButtonVariant.outline,
                        text: "Sign In",
                        onPressed: () {
                          Get.to(
                            () => SigninPage(),
                            transition: Transition.cupertino,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 1200),
                      child: Button(
                        text: "Sign Up",
                        onPressed: () {
                          Get.to(
                            () => SignupPage(),
                            transition: Transition.cupertino,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
