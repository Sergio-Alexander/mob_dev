import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'app_status.dart';
import 'router.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RecordingState(),
      child: MyApp(),


    ),
  );
}

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





