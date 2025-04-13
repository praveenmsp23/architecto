import 'package:flutter/cupertino.dart';

class LaborScreen extends StatelessWidget {
  const LaborScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Labor'),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Labor Screen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}