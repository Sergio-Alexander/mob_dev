import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> setupFirebase() async{

  try{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('Firebase initalized successfully');
  } catch (e){
    print('Firebase did not initialize');
  }
}