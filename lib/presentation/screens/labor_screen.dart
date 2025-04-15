import 'package:flutter/cupertino.dart';

class LaborScreen extends StatelessWidget {
  const LaborScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: const Center(
        child: Text(
          'Labor Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
