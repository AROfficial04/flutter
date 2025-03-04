// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDHd6DkwaRSkY2XTwb4WejhfP3chIwVUsk',
    appId: '1:682705003276:web:cecd7653255d7d6bd25f29',
    messagingSenderId: '682705003276',
    projectId: 'aceacademy-61b24',
    authDomain: 'aceacademy-61b24.firebaseapp.com',
    storageBucket: 'aceacademy-61b24.appspot.com',
    measurementId: 'G-VTZP8NCGZV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpPCJFpCecAk65uCSYFWNyPSA-RWnxyBY',
    appId: '1:682705003276:android:4d37e9526b69514cd25f29',
    messagingSenderId: '682705003276',
    projectId: 'aceacademy-61b24',
    storageBucket: 'aceacademy-61b24.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3ieUDJW61ttlWpXrgBwfNq_GD7wPVM2I',
    appId: '1:682705003276:ios:47bbce3cbcd4f129d25f29',
    messagingSenderId: '682705003276',
    projectId: 'aceacademy-61b24',
    storageBucket: 'aceacademy-61b24.appspot.com',
    iosBundleId: 'com.example.aceacademy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB3ieUDJW61ttlWpXrgBwfNq_GD7wPVM2I',
    appId: '1:682705003276:ios:087ad52c4c4baebfd25f29',
    messagingSenderId: '682705003276',
    projectId: 'aceacademy-61b24',
    storageBucket: 'aceacademy-61b24.appspot.com',
    iosBundleId: 'com.example.aceacademy.RunnerTests',
  );
}
