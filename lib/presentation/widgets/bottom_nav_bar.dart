import 'package:flutter/cupertino.dart';
import 'package:architecto/config/theme_config.dart';

class BottomNavBarItem {
  final IconData icon;
  final Widget widget;

  const BottomNavBarItem({
    required this.icon,
    required this.widget,
  });
}

class BottomNavBar extends StatefulWidget {
  final List<BottomNavBarItem> items;
  final int currentIndex;
  final Function(int) onIndexChanged;

  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavPill(),
            const SizedBox(width: 12),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavPill() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ThemeConfig.getNavPillBackgroundColor(context),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < widget.items.length; i++)
            _buildTab(index: i),
        ],
      ),
    );
  }

  Widget _buildTab({required int index}) {
    final theme = CupertinoTheme.of(context);
    final item = widget.items[index];
    final isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => widget.onIndexChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 40,
        width: 40,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? theme.barBackgroundColor : null,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: isSelected ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          builder: (context, value, _) {
            return Opacity(
              opacity: 0.8 + (0.2 * value),
              child: Icon(
                item.icon,
                color: ThemeConfig.getNavIconColor(context),
                size: 20,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    final theme = CupertinoTheme.of(context);
    
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          CupertinoIcons.plus,
          color: CupertinoColors.white,
          size: 20,
        ),
      ),
    );
  }
}
