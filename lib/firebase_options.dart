import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCTQJB4OaB6akp43NW77wIzTEstjsPHfXI',
    appId: '1:130270319796:web:8ca95541006fd4176ab3e1',
    messagingSenderId: '130270319796',
    projectId: 'infracare-e05ae',
    storageBucket: 'infracare-e05ae.firebasestorage.app',
  );
}