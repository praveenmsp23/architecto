import 'package:flutter/cupertino.dart';

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Salary'),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Salary Screen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
} 