import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:architecto/config/theme.dart';
import 'package:architecto/providers/auth/provider.dart';
import 'package:architecto/providers/auth/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'config/config.dart';
import 'config/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Config.initialize();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthProvider());

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(Architecto(themeMode: savedThemeMode));
}

class Architecto extends StatefulWidget {
  final AdaptiveThemeMode? themeMode;

  const Architecto({Key? key, @required this.themeMode}) : super(key: key);

  @override
  State<Architecto> createState() => _ArchitectoState();
}

class _ArchitectoState extends State<Architecto> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: CupertinoAdaptiveTheme(
        debugShowFloatingThemeButton: true,
        light: Themes().lightTheme,
        dark: Themes().darkTheme,
        initial: AdaptiveThemeMode.light,
        builder: (theme) => GetCupertinoApp(
          debugShowCheckedModeBanner: false,
          title: Config.appName,
          theme: theme,
          home: AuthWrapper(),
        ),
      ),
    );
  }
}
