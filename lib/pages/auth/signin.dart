import 'package:animate_do/animate_do.dart';
import 'package:architecto/extensions/theme.dart';
import 'package:architecto/models/result.dart';
import 'package:architecto/pages/auth/signup.dart';
import 'package:architecto/providers/auth/provider.dart';
import 'package:architecto/utils/common.dart';
import 'package:architecto/widgets/button.dart';
import 'package:architecto/widgets/input.dart';
import 'package:architecto/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  AuthProvider _auth = Get.find();
  bool _isLoading = false;
  bool _showPassword = false;

  String _emailError = "";
  String _passwordError = "";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    if (_emailError.isNotEmpty || _passwordError.isNotEmpty) return;
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });
    Result result = await _auth.signIn(email, password);
    if (!result.success) {
      SnackBar().errorMessage(result.message);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _onEmailChange() {
    String email = _emailController.text;
    if (!GetUtils.isEmail(email)) {
      setState(() {
        _emailError = "Invalid email";
      });
    } else {
      setState(() {
        _emailError = "";
      });
    }
  }

  void _onPasswordChange() {
    String password = _passwordController.text;
    Result<String> _passwordResult = checkPasswordStrength(password);
    setState(() {
      _passwordError = _passwordResult.message;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChange);
    _passwordController.removeListener(_onPasswordChange);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInRight(
                        delay: const Duration(microseconds: 200),
                        child: Text(
                          "Let's sign you in.",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      FadeInRight(
                        delay: const Duration(microseconds: 200),
                        child: Text(
                          "Welcome back! \nYou've been missed",
                          style: TextStyle(
                            fontSize: 36,
                            height: 1.25,
                            color: context.secondaryTextColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Input(
                      controller: _emailController,
                      error: _emailError,
                      label: "Email",
                      type: TextInputType.emailAddress,
                      placeholder: "name@example.com",
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Input(
                      controller: _passwordController,
                      error: _passwordError,
                      label: "Password",
                      type: TextInputType.text,
                      obscureText: !_showPassword,
                      suffix: GestureDetector(
                        onTap: () => _onShowPassword(),
                        child: Icon(
                          _showPassword
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                        ),
                      ),
                      placeholder: "Password",
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: Button(
                      text: "Sign In",
                      isLoading: _isLoading,
                      onPressed: () => _signIn(),
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: context.secondaryTextColor,
                            ),
                          ),
                          SizedBox(width: 8),
                          Button(
                            text: "Sign Up",
                            size: ButtonSize.small,
                            variant: ButtonVariant.link,
                            isEnabled: !_isLoading,
                            onPressed: () => Get.to(() => SignupPage()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
