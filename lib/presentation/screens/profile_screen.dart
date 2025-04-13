import 'package:flutter/cupertino.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profile'),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Profile Screen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
} 