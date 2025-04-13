import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:architecto/routes/app_pages.dart';
import 'package:architecto/config/app_config.dart';
import 'package:architecto/services/theme/theme_service.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeController());
    return Obx(() => GetCupertinoApp(
      title: AppConfig.instance.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeService.to.theme,
      defaultTransition: Transition.cupertino,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ));
  }
}