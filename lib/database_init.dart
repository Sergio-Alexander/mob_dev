import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/floor_model/recorder_database/recorder_database.dart';

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
            child: this.child,// Pass the database to EmotionRecorder
          );
        } else {
          print('Waiting for database initialization...');
          return CircularProgressIndicator();
        }
      },
    );
  }
}