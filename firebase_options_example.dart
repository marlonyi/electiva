// Archivo de configuración de Firebase - EJEMPLO
// COPIA este archivo como firebase_options.dart y reemplaza los valores
// con tu configuración real de Firebase Console

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

  // CONFIGURACIÓN PARA WEB
  // Obtén estos valores de: Firebase Console > Project Settings > General > Your apps > Web app
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD1234567890abcdefghijklmnopqrstuvw', // Tu API Key
    appId: '1:123456789012:web:abcdef1234567890abcdef', // Tu App ID
    messagingSenderId: '123456789012', // Tu Messaging Sender ID
    projectId: 'tu-proyecto-firebase', // Tu Project ID
    authDomain: 'tu-proyecto-firebase.firebaseapp.com', // Tu Auth Domain
    storageBucket: 'tu-proyecto-firebase.appspot.com', // Tu Storage Bucket
    measurementId: 'G-ABCDEFGHIJK', // Tu Measurement ID (opcional)
  );

  // CONFIGURACIÓN PARA ANDROID
  // Obtén estos valores agregando una app Android en Firebase Console
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1234567890abcdefghijklmnopqrstuvw',
    appId: '1:123456789012:android:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'tu-proyecto-firebase',
    storageBucket: 'tu-proyecto-firebase.appspot.com',
  );

  // CONFIGURACIÓN PARA iOS
  // Obtén estos valores agregando una app iOS en Firebase Console
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1234567890abcdefghijklmnopqrstuvw',
    appId: '1:123456789012:ios:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'tu-proyecto-firebase',
    storageBucket: 'tu-proyecto-firebase.appspot.com',
  );

  // CONFIGURACIÓN PARA macOS
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1234567890abcdefghijklmnopqrstuvw',
    appId: '1:123456789012:macos:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'tu-proyecto-firebase',
    storageBucket: 'tu-proyecto-firebase.appspot.com',
  );

  // CONFIGURACIÓN PARA WINDOWS
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD1234567890abcdefghijklmnopqrstuvw',
    appId: '1:123456789012:windows:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'tu-proyecto-firebase',
    storageBucket: 'tu-proyecto-firebase.appspot.com',
  );
}

/*
INSTRUCCIONES PARA CONFIGURAR FIREBASE:

1. Ve a https://console.firebase.google.com/
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita Authentication:
   - Ve a Authentication > Sign-in method
   - Habilita "Email/Password"
   - Habilita "Google" (necesitas configurar OAuth consent screen)

4. Agrega tu app web:
   - Ve a Project settings > General
   - En "Your apps", haz clic en "Add app" > Web
   - Copia la configuración que te da Firebase

5. Reemplaza los valores en este archivo con tu configuración real

6. Para Google Sign-In:
   - Ve a Authentication > Sign-in method > Google
   - Asegúrate de que esté habilitado
   - Agrega tu dominio a "Authorized domains" si es necesario

¡IMPORTANTE!
- Nunca commits este archivo con credenciales reales
- Usa variables de entorno para producción
- Mantén las API keys seguras
*/
