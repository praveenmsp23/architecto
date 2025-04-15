import 'package:flutter/cupertino.dart';

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: const Center(
        child: Text(
          'Salary Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
