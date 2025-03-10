import 'package:animate_do/animate_do.dart';
import 'package:architecto/extensions/theme.dart';
import 'package:architecto/models/result.dart';
import 'package:architecto/providers/auth/provider.dart';
import 'package:architecto/widgets/button.dart';
import 'package:architecto/widgets/input.dart';
import 'package:architecto/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateOrganizationPage extends StatefulWidget {
  const CreateOrganizationPage({super.key});

  @override
  State<CreateOrganizationPage> createState() => _CreateOrganizationPageState();
}

class _CreateOrganizationPageState extends State<CreateOrganizationPage> {
  AuthProvider _auth = Get.find();
  bool _isLoading = false;

  String _nameError = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future<void> _signUp() async {
    if (_nameError.isNotEmpty) return;
    String name = _nameController.text;
    String about = _aboutController.text;
    String address = _addressController.text;

    setState(() {
      _isLoading = true;
    });

    Result result = await _auth.createOrganization(name, about, address);
    if (!result.success) {
      debugPrint(result.message);
      SnackBar().errorMessage(result.message);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onNameChange() {
    String name = _nameController.text;
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Please enter your organization name';
      });
    } else if (name.length < 3) {
      setState(() {
        _nameError = "Name must contain at least 3 characters";
      });
    } else {
      setState(() {
        _nameError = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChange);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChange);
    _nameController.dispose();
    _aboutController.dispose();
    _addressController.dispose();
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
                          "Set up your business.",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      FadeInRight(
                        delay: const Duration(microseconds: 200),
                        child: Text(
                          "We're thrilled to help you build the future.",
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
                      controller: _nameController,
                      error: _nameError,
                      label: "Name",
                      type: TextInputType.name,
                      placeholder: "Company name",
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Input(
                      controller: _aboutController,
                      label: "About",
                      type: TextInputType.text,
                      placeholder: "Something about your company.",
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Input(
                      controller: _addressController,
                      label: "Address",
                      type: TextInputType.streetAddress,
                      maxLines: 2,
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: Button(
                      text: "Register",
                      isLoading: _isLoading,
                      onPressed: () => _signUp(),
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Button(
                        text: "Sign Out",
                        isEnabled: !_isLoading,
                        variant: ButtonVariant.outline,
                        onPressed: () => _auth.signOut(),
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
