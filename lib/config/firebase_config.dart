import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase configuration helper
class FirebaseConfig {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: _getFirebaseOptions(),
    );
  }

  static FirebaseOptions _getFirebaseOptions() {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "WEB_API_KEY",
        authDomain: "YOUR_PROJECT.firebaseapp.com",
        projectId: "YOUR_PROJECT",
        storageBucket: "YOUR_PROJECT.appspot.com",
        messagingSenderId: "MESSAGING_SENDER_ID",
        appId: "WEB_APP_ID",
      );
    } else {
      // iOS-specific Firebase configuration
      return const FirebaseOptions(
        apiKey: "IOS_API_KEY",
        appId: "IOS_APP_ID",
        messagingSenderId: "MESSAGING_SENDER_ID",
        projectId: "YOUR_PROJECT",
        storageBucket: "YOUR_PROJECT.appspot.com",
        iosBundleId: "com.example.architecto",
      );
    }
  }
}