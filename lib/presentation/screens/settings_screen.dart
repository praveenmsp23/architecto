import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:architecto/services/theme/theme_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            _buildThemeSelector(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dark Mode'),
              Obx(() => CupertinoSwitch(
                value: ThemeService.to.isDarkMode,
                onChanged: (_) => ThemeService.to.toggleTheme(),
              )),
            ],
          ),
        ],
      ),
    );
  }
}