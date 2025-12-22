import 'package:flutter/foundation.dart';

class ApiConstants {
  // Use 127.0.0.1 for Web and iOS Simulator
  // Use 10.0.2.2 for Android Emulator
  static String get baseUrl {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api';
    }
    return 'http://127.0.0.1:5000/api';
  }

  static String get authUrl {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api/auth/firebase-login';
    }
    return 'http://127.0.0.1:5000/api/auth/firebase-login';
  }

  static String get ocrUrl {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api/ocr/translate';
    }
    return 'http://127.0.0.1:5000/api/ocr/translate';
  }
}
