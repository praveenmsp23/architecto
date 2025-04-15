import 'package:flutter/cupertino.dart';
import 'package:architecto/constants/app_constants.dart';
import 'package:architecto/services/auth/auth_service.dart';
import 'package:architecto/services/theme/theme_service.dart';
import 'package:architecto/config/theme_config.dart';
import 'package:get/get.dart';

class TopNavBar extends StatefulWidget {
  const TopNavBar({super.key});

  @override
  State<TopNavBar> createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.defaultPadding / 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hey ${AuthService.user?.name ?? 'User'}!",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Have a good day forward..",
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              _showActionSheet(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).barBackgroundColor,
                borderRadius: ThemeConfig.radiusDefault,
                border:
                    Border.fromBorderSide(ThemeConfig.standardBorder(context)),
              ),
              child: const Icon(
                CupertinoIcons.settings,
                size: 20,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              ThemeService.to.toggleTheme();
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Icon(
                    ThemeService.to.isDarkMode
                        ? CupertinoIcons.sun_max_fill
                        : CupertinoIcons.moon_fill,
                    color: ThemeService.to.isDarkMode
                        ? CupertinoColors.systemYellow
                        : CupertinoColors.systemBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    ThemeService.to.isDarkMode ? 'Light Mode' : 'Dark Mode',
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              AuthService().signOut();
              Navigator.pop(context);
            },
            isDestructiveAction: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.square_arrow_right,
                  color: CupertinoColors.systemRed,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text('Sign Out'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
