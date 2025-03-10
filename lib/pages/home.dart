import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const _navItems = [
    (icon: CupertinoIcons.home, label: 'Home', screen: Placeholder()),
    (icon: CupertinoIcons.search, label: 'Search', screen: Placeholder()),
    (icon: CupertinoIcons.person, label: 'Profile', screen: Placeholder()),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          _navItems[_selectedIndex].screen,
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: CupertinoColors.systemGrey.withOpacity(0.1),
              child: GNav(
                gap: 8,
                activeColor: CupertinoColors.white,
                color: CupertinoColors.systemGrey,
                backgroundColor: CupertinoColors.activeBlue,
                tabBackgroundColor: CupertinoColors.activeBlue.withOpacity(0.6),
                padding: const EdgeInsets.all(16),
                onTabChange: (index) => setState(() => _selectedIndex = index),
                tabs: [
                  for (final item in _navItems)
                    GButton(
                      icon: item.icon,
                      text: item.label,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
