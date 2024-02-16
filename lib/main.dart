import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'app_status.dart';
import 'floor_model/recorder_database/recorder_database.dart';
import 'router.dart';

import 'database_init.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => RecordingState(),
//       child: MyApp(),
//     ),
//   );
// }

// void main() {
//   runApp(
//     DatabaseInitializer(
//       child: Builder(
//         builder: (context) {
//           return ChangeNotifierProvider(
//             create: (context) {
//               final database = Provider.of<RecorderDatabase>(context, listen: false);
//               return RecordingState(database: database);
//             },
//             child: MyApp(),
//           );
//         },
//       ),
//     ),
//   );
// }

void main() {
  runApp(
    DatabaseInitializer(
      child: Builder(
        builder: (context) {
          final database = Provider.of<RecorderDatabase>(context, listen: false);
          final recordingState = RecordingState(database: database);
          return FutureBuilder(
            future: Future.wait([
              recordingState.loadLastStatus(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ChangeNotifierProvider.value(
                  value: recordingState,
                  child: MyApp(),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DatabaseInitializer(
        child: MaterialApp.router(
          title: 'My App',
          theme: ThemeData(primarySwatch: Colors.blue),
          routerConfig: appRouter,
        )
    );
  }
}
