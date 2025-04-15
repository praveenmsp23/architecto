import 'package:architecto/presentation/screens/attendance_screen.dart';
import 'package:architecto/presentation/screens/labor_screen.dart';
import 'package:architecto/presentation/screens/salary_screen.dart';
import 'package:architecto/presentation/widgets/top_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:architecto/presentation/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<BottomNavBarItem> _items = [
    BottomNavBarItem(icon: CupertinoIcons.calendar, widget: AttendanceScreen()),
    BottomNavBarItem(icon: CupertinoIcons.person_2_fill, widget: LaborScreen()),
    BottomNavBarItem(icon: CupertinoIcons.money_dollar, widget: SalaryScreen()),
  ];

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const TopNavBar(),
                Expanded(
                  child: _items[_currentIndex].widget,
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNavBar(
                currentIndex: _currentIndex,
                onIndexChanged: _onIndexChanged,
                items: _items,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
