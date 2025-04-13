import 'package:flutter/cupertino.dart';

class OrganizationScreen extends StatelessWidget {
  const OrganizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Organization'),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Organization Screen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}