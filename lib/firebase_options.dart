// File generated for the BrewStreet Firebase project (brewstreet-279b5).
// Values taken from android/app/google-services.json and
// ios/Runner/GoogleService-Info.plist.
//
// Only Android and iOS are configured. To add web/macos/windows, run:
//   flutterfire configure
//
// See: https://firebase.google.com/docs/flutter/setup

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web is not configured. Run "flutterfire configure" to add it.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          '${defaultTargetPlatform.name} is not configured. '
          'Run "flutterfire configure" to add it.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSRuQ82_zaX_NSI2Tdb4Ab8a_vUn9QZ2k',
    appId: '1:32669944636:android:ec576320ca3ecb5a59ec39',
    messagingSenderId: '32669944636',
    projectId: 'brewstreet-279b5',
    storageBucket: 'brewstreet-279b5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCk7MjQCKqI5MkmUFllHKG-letIBdQBYUM',
    appId: '1:32669944636:ios:82894888987c407059ec39',
    messagingSenderId: '32669944636',
    projectId: 'brewstreet-279b5',
    storageBucket: 'brewstreet-279b5.firebasestorage.app',
    iosBundleId: 'com.example.projectCoffinder',
  );
}
