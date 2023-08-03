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
    apiKey: 'AIzaSyBx4YFrLwH3BTYjLQUC8thsbzcHXxNDFSU',
    appId: '1:486061189377:web:a5624bd6e4d3b928de5300',
    messagingSenderId: '486061189377',
    projectId: 'tiktok-clone-qwer',
    authDomain: 'tiktok-clone-qwer.firebaseapp.com',
    databaseURL: 'https://tiktok-clone-qwer-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tiktok-clone-qwer.appspot.com',
    measurementId: 'G-ZSH81HBE35',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvZruV0Lmex_X9ZvLRbcK8rlknMfdk4Q8',
    appId: '1:486061189377:android:0d1143e129802e89de5300',
    messagingSenderId: '486061189377',
    projectId: 'tiktok-clone-qwer',
    databaseURL: 'https://tiktok-clone-qwer-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tiktok-clone-qwer.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDAkHN50K2jnsArTQLG_3J0U9MktR1_rk',
    appId: '1:486061189377:ios:a2d51d2245d68bfbde5300',
    messagingSenderId: '486061189377',
    projectId: 'tiktok-clone-qwer',
    databaseURL: 'https://tiktok-clone-qwer-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tiktok-clone-qwer.appspot.com',
    androidClientId: '486061189377-gvm0fnhao7gbiffmko9bhdqnijjhb8al.apps.googleusercontent.com',
    iosClientId: '486061189377-n5ckj1v00432598q1m4u70tkn6uove1n.apps.googleusercontent.com',
    iosBundleId: 'com.example.tiktokClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDAkHN50K2jnsArTQLG_3J0U9MktR1_rk',
    appId: '1:486061189377:ios:a2d51d2245d68bfbde5300',
    messagingSenderId: '486061189377',
    projectId: 'tiktok-clone-qwer',
    databaseURL: 'https://tiktok-clone-qwer-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tiktok-clone-qwer.appspot.com',
    androidClientId: '486061189377-gvm0fnhao7gbiffmko9bhdqnijjhb8al.apps.googleusercontent.com',
    iosClientId: '486061189377-n5ckj1v00432598q1m4u70tkn6uove1n.apps.googleusercontent.com',
    iosBundleId: 'com.example.tiktokClone',
  );
}
