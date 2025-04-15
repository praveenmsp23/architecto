import 'package:flutter/cupertino.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: const Center(
        child: Text(
          'Attendance Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
