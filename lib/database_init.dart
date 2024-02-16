import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/floor_model/recorder_database/recorder_database.dart';
import 'app_status.dart';

class DatabaseInitializer extends StatelessWidget {
  final Widget child;

  DatabaseInitializer({required this.child});

  @override
  Widget build(BuildContext context) {
    final Future<RecorderDatabase> database = $FloorRecorderDatabase
        .databaseBuilder('recorder_database.db')
        .build();

    return FutureBuilder<RecorderDatabase>(
      future: database,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.error != null) {
            print('Error initializing database: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          }
          final database = snapshot.data;
          print('Database initialized successfully');
          return Provider<RecorderDatabase>.value(
            value: database!,
            child: this.child,// Pass the database to the router
          );
        } else {
          print('Waiting for database initialization...');
          return CircularProgressIndicator();
        }
      },
    );
  }
}

// class DatabaseInitializer extends StatelessWidget {
//   final Widget child;
//
//   DatabaseInitializer({required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     final Future<RecorderDatabase> database = $FloorRecorderDatabase
//         .databaseBuilder('recorder_database.db')
//         .build();
//
//     return FutureBuilder<RecorderDatabase>(
//       future: database,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.error != null) {
//             print('Error initializing database: ${snapshot.error}');
//             return Text('Error: ${snapshot.error}');
//           }
//           final database = snapshot.data;
//           if (database != null) {
//             return ChangeNotifierProvider(
//               create: (context) => RecordingState(database: database),
//               child: Provider<RecorderDatabase>.value(
//                 value: database,
//                 child: this.child,
//               ),
//             );
//           } else {
//             print('Error: Database is null');
//             return Text('Error: Database is null');
//           }
//         } else {
//           print('Waiting for database initialization...');
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }