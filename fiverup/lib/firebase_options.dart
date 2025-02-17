// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDf-2d_AEjeANpjrUJOWDGRsAGgRoPJs-k',
    appId: '1:487306851360:android:1377e55df1242db2b07845',
    messagingSenderId: '487306851360',
    projectId: 'fiverup-a589b',
    storageBucket: 'fiverup-a589b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANeuUyN-XKXWN9FN3M9yFbGqa6gUYzAes',
    appId: '1:487306851360:ios:2183c115dd69097cb07845',
    messagingSenderId: '487306851360',
    projectId: 'fiverup-a589b',
    storageBucket: 'fiverup-a589b.firebasestorage.app',
    iosBundleId: 'com.example.fiverup',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCS5C-JEqmTxGVzikYtT7g3a3zAQ-6GW-I',
    appId: '1:487306851360:web:8d63c40bdf9caca4b07845',
    messagingSenderId: '487306851360',
    projectId: 'fiverup-a589b',
    authDomain: 'fiverup-a589b.firebaseapp.com',
    storageBucket: 'fiverup-a589b.firebasestorage.app',
    measurementId: 'G-0Q6RZD8MSY',
  );

}