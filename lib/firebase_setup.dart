import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> setupFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool isFirebaseConnected = Firebase.apps.isNotEmpty;

  if (isFirebaseConnected) {
    print('Firebase is already connected');
  } else {
    print('Firebase is not connected yet');
  }


  FirebaseApp app = Firebase.app();
  String projectId = app.options.projectId;
  print("Connected to firebase server: $projectId");
}