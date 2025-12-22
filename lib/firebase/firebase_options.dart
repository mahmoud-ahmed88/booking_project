import 'package:firebase_core/firebase_core.dart';

//for connection with firebase
class DefaultFirebaseOptions {
  static FirebaseOptions get android => const FirebaseOptions(
        apiKey: "YOUR_API_KEY_HERE", // <-- استبدل هذا بمفتاح API الخاص بك
        appId: "1:1234567890:android:abcdef",
        messagingSenderId: "1234567890",
        projectId: "docline-project",
      );
}
