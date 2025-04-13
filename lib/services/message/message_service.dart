import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Message {
  static void error(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        CupertinoIcons.xmark,
        color: CupertinoColors.white,
      ),
      backgroundColor: CupertinoColors.systemRed,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
    ));
  }

  static void success(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        CupertinoIcons.checkmark,
        color: CupertinoColors.white,
      ),
      backgroundColor: CupertinoColors.systemGreen,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
    ));
  }

  static void info(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        CupertinoIcons.info,
        color: CupertinoColors.white,
      ),
      backgroundColor: CupertinoColors.systemBlue,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
    ));
  }

  static void warning(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        CupertinoIcons.exclamationmark_triangle,
        color: CupertinoColors.white,
      ),
      backgroundColor: CupertinoColors.systemOrange,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
    ));
  }
}