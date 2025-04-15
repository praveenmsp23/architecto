import 'package:flutter/cupertino.dart';
import 'package:architecto/constants/app_constants.dart';
import 'package:architecto/services/auth/auth_service.dart';
import 'package:architecto/services/theme/theme_service.dart';
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
          Obx(
            () => CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => ThemeService.to.toggleTheme(),
              child: Icon(
                ThemeService.to.isDarkMode
                    ? CupertinoIcons.sun_max_fill
                    : CupertinoIcons.moon_fill,
                size: 24,
                color: ThemeService.to.isDarkMode
                    ? CupertinoColors.systemYellow
                    : CupertinoColors.systemBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
