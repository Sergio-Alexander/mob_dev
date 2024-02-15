import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'app_status.dart';
import 'router.dart';

import 'diet_recorder.dart';
import 'emotion_recorder.dart';
import 'workout_recorder.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RecordingState(),
      child: MyApp(),


    ),
  );
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensure plugin services are initialized
//
//   // Create an instance of RecordingState
//   final recordingState = RecordingState();
//
//   // Load the last recorded data asynchronously
//   await recordingState.loadLastRecordedData();
//
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => recordingState,
//       child: MyApp(),
//     ),
//   );
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter,

    );
  }
}





