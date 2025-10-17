// Archivo de configuración de Firebase
// Este archivo contiene la configuración necesaria para conectar con Firebase
// Necesitas crear un proyecto en Firebase Console y agregar tu app Flutter

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Configuración para Web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAnuuq7WHexGc0Vk_n86NWYQs2JvWaYOAs",
    authDomain: "electiva-5638d.firebaseapp.com",
    projectId: "electiva-5638d",
    storageBucket: "electiva-5638d.firebasestorage.app",
    messagingSenderId: "871562645439",
    appId: "1:871562645439:web:f9a57d248c066872f61b0a",
    measurementId: "G-NXBMRPWY1W",
  );

  // Configuración para Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TU_API_KEY_AQUI',
    appId: 'TU_APP_ID_AQUI',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID_AQUI',
    projectId: 'TU_PROJECT_ID_AQUI',
    storageBucket: 'TU_PROJECT_ID_AQUI.appspot.com',
  );

  // Configuración para iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TU_API_KEY_AQUI',
    appId: 'TU_APP_ID_AQUI',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID_AQUI',
    projectId: 'TU_PROJECT_ID_AQUI',
    storageBucket: 'TU_PROJECT_ID_AQUI.appspot.com',
  );

  // Configuración para macOS
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'TU_API_KEY_AQUI',
    appId: 'TU_APP_ID_AQUI',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID_AQUI',
    projectId: 'TU_PROJECT_ID_AQUI',
    storageBucket: 'TU_PROJECT_ID_AQUI.appspot.com',
  );

  // Configuración para Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'TU_API_KEY_AQUI',
    appId: 'TU_APP_ID_AQUI',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID_AQUI',
    projectId: 'TU_PROJECT_ID_AQUI',
    storageBucket: 'TU_PROJECT_ID_AQUI.appspot.com',
  );
}
