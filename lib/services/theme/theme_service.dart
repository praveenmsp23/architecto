import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:architecto/config/theme_config.dart';

/// Service class for managing theme settings in the app
class ThemeService extends GetxService {
  static ThemeService get to => Get.find<ThemeService>();
  final _storage = GetStorage();
  static const _themeKey = 'is_dark_mode';
  
  final Rx<bool> _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  
  CupertinoThemeData get theme => 
      _isDarkMode.value ? ThemeConfig.darkTheme : ThemeConfig.lightTheme;

  Future<ThemeService> init() async {
    _isDarkMode.value = _storage.read(_themeKey) ?? false;
    return this;
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _storage.write(_themeKey, _isDarkMode.value);
    Get.forceAppUpdate();
  }
}

/// Controller class for theme management in UI components
class ThemeController extends GetxController {
  ThemeController();
  bool get isDarkMode => ThemeService.to.isDarkMode;
  void toggleTheme() => ThemeService.to.toggleTheme();
}