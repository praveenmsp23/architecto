import 'package:flutter/cupertino.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Attendance'),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Attendance Screen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
} 