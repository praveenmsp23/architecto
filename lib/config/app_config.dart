import 'dart:async';
import 'package:flutter/foundation.dart';

enum Environment { dev, prod }

class AppConfig {
  final String appName;
  final Environment environment;
  final bool enableAnalytics;
  final bool enableCrashlytics;
  final int organizationInviteExpiryDays;

  static late final AppConfig _instance;

  factory AppConfig({
    required String appName,
    required Environment environment,
    required bool enableAnalytics,
    required bool enableCrashlytics,
    required int organizationInviteExpiryDays,
  }) {
    _instance = AppConfig._internal(
      appName: appName,
      environment: environment,
      enableAnalytics: enableAnalytics,
      enableCrashlytics: enableCrashlytics,
      organizationInviteExpiryDays: organizationInviteExpiryDays,
    );
    return _instance;
  }

  AppConfig._internal({
    required this.appName,
    required this.environment,
    required this.enableAnalytics,
    required this.enableCrashlytics,
    required this.organizationInviteExpiryDays,
  });

  static AppConfig get instance => _instance;

  static bool isProduction() => _instance.environment == Environment.prod;
  static bool isDevelopment() => _instance.environment == Environment.dev;

  static Future<void> initialize() async {
    AppConfig(
      appName: 'Architecto',
      environment: kReleaseMode ? Environment.prod : Environment.dev,
      enableAnalytics: kReleaseMode,
      enableCrashlytics: kReleaseMode,
      organizationInviteExpiryDays: 7,
    );
  }
}