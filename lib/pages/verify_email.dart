import 'package:animate_do/animate_do.dart';
import 'package:architecto/extensions/theme.dart';
import 'package:architecto/models/common.dart';
import 'package:architecto/providers/auth/provider.dart';
import 'package:architecto/widgets/button.dart';
import 'package:architecto/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  AuthProvider _auth = Get.find();

  Future<void> _sendMail() async {
    Result result = await _auth.sendVerificationEmail();
    if (!result.success) {
      SnackBar().errorMessage(result.message);
    }
  }

  @override
  void initState() {
    _sendMail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                          "Verify your email",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "We have sent an email to ",
                              style: TextStyle(
                                color: context.secondaryTextColor,
                                height: 1.25,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: "${widget.email}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                height: 1.25,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ".\nClick on the link to verify your account.",
                              style: TextStyle(
                                color: context.secondaryTextColor,
                                height: 1.25,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
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
                        text: "Refresh",
                        onPressed: () => _sendMail(),
                      ),
                    ),
                    SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 1200),
                      child: Button(
                        text: "Sign Out",
                        variant: ButtonVariant.destructive,
                        onPressed: () => _auth.signOut(),
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
