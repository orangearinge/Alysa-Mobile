import 'package:flutter/foundation.dart';

class ApiConstants {
  // static const String _localAndroid = 'http://10.0.2.2:5000/api';
  // static const String _localOther = 'http://127.0.0.1:5000/api';

  // kalau mau pakai ngrok, tinggal ganti ini
  static const String _ngrok = 'http://192.168.1.3:5000/api';

  static String get baseUrl {
    // ===== PILIH SALAH SATU =====

    // LOCAL
    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   return _localAndroid;
    // }
    // return _localOther;

    // NGROK (kalau mau pakai ngrok, comment yang atas)
    return _ngrok;
  }

  static String get authUrl => '$baseUrl/auth/firebase-login';
  static String get ocrUrl => '$baseUrl/ocr/translate';
}

// import 'package:flutter/foundation.dart';

// class ApiConstants {
//   // Use 127.0.0.1 for Web and iOS Simulator
//   // Use 10.0.2.2 for Android Emulator
//   static String get baseUrl {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       return 'http://10.0.2.2:5000/api';
//     }
//     return 'http://127.0.0.1:5000/api';
//   }

//   static String get authUrl {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       return 'http://10.0.2.2:5000/api/auth/firebase-login';
//     }
//     return 'http://127.0.0.1:5000/api/auth/firebase-login';
//   }

//   static String get ocrUrl {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       return 'http://10.0.2.2:5000/api/ocr/translate';
//     }
//     return 'http://127.0.0.1:5000/api/ocr/translate';
//   }
// }

// import 'package:flutter/foundation.dart';

// class ApiConstants {
//   // Use 127.0.0.1 for Web and iOS Simulator
//   // Use 10.0.2.2 for Android Emulator
//   static String get baseUrl {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       return 'http://firmamental-rosella-vexatious.ngrok-free.dev/api';
//     }
//     return 'http://firmamental-rosella-vexatious.ngrok-free.dev/api';
//   }

//   static String get authUrl {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       return 'http://firmamental-rosella-vexatious.ngrok-free.dev/api/auth/firebase-login';
//     }
//     return 'http://firmamental-rosella-vexatious.ngrok-free.dev/api/auth/firebase-login';
//   }

//   static String get ocrUrl {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       return 'http://firmamental-rosella-vexatious.ngrok-free.dev/api/ocr/translate';
//     }
//     return 'http://firmamental-rosella-vexatious.ngrok-free.dev/api/ocr/translate';
//   }
// }
