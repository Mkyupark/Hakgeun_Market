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
    apiKey: 'AIzaSyA_OqTDW-vcStJ6EgmQfZqLjVWpeqF7nFs',
    appId: '1:227465765720:web:125591abe73aaf86c17b2d',
    messagingSenderId: '227465765720',
    projectId: 'market-5f9bf',
    authDomain: 'market-5f9bf.firebaseapp.com',
    storageBucket: 'market-5f9bf.appspot.com',
    measurementId: 'G-21RS8VMJ1N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAfPLoddhurL2GG55rRuzujgDmetgIvgV4',
    appId: '1:227465765720:android:98ffdd30a7dc376fc17b2d',
    messagingSenderId: '227465765720',
    projectId: 'market-5f9bf',
    storageBucket: 'market-5f9bf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCScD9TpoWMGene3u5bTpJ1eVJ9AEJOfts',
    appId: '1:227465765720:ios:6592728a46ab135bc17b2d',
    messagingSenderId: '227465765720',
    projectId: 'market-5f9bf',
    storageBucket: 'market-5f9bf.appspot.com',
    iosBundleId: 'com.example.hakgeunMarket',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCScD9TpoWMGene3u5bTpJ1eVJ9AEJOfts',
    appId: '1:227465765720:ios:490f9a0d65cf5fdec17b2d',
    messagingSenderId: '227465765720',
    projectId: 'market-5f9bf',
    storageBucket: 'market-5f9bf.appspot.com',
    iosBundleId: 'com.example.hakgeunMarket.RunnerTests',
  );
}
