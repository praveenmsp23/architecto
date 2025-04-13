import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:architecto/services/storage/storage_service.dart';
import 'package:architecto/services/theme/theme_service.dart';
import 'package:architecto/app/app.dart';
import 'package:architecto/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await AppConfig.initialize();
  await Firebase.initializeApp();
  await GetStorage.init();
  await StorageService.init();
  await Get.putAsync(() => ThemeService().init());
  
  runApp(const App());
}
