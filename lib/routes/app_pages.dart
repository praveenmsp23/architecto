import 'package:get/get.dart';
import 'package:architecto/presentation/screens/welcome_screen.dart';
import 'package:architecto/presentation/screens/home_screen.dart';
import 'package:architecto/presentation/screens/login_screen.dart';
import 'package:architecto/presentation/screens/register_screen.dart';
import 'package:architecto/presentation/screens/organization_screen.dart';
import 'package:architecto/presentation/screens/labor_screen.dart';
import 'package:architecto/presentation/screens/attendance_screen.dart';
import 'package:architecto/presentation/screens/salary_screen.dart';
import 'package:architecto/presentation/screens/profile_screen.dart';
import 'package:architecto/presentation/screens/settings_screen.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const ORGANIZATION = '/organization';
  static const LABOR = '/labor';
  static const ATTENDANCE = '/attendance';
  static const SALARY = '/salary';
  static const PROFILE = '/profile';
  static const SETTINGS = '/settings';
}

class AppPages {
  static const INITIAL = Routes.INITIAL;
  static final List<GetPage> routes = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: Routes.ORGANIZATION,
      page: () => const OrganizationScreen(),
    ),
    GetPage(
      name: Routes.LABOR,
      page: () => const LaborScreen(),
    ),
    GetPage(
      name: Routes.ATTENDANCE,
      page: () => const AttendanceScreen(),
    ),
    GetPage(
      name: Routes.SALARY,
      page: () => const SalaryScreen(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsScreen(),
    ),
  ];
}