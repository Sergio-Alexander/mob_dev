import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mob_dev/app_localization.dart';
import 'package:mob_dev/pages/settings.dart';
import 'package:provider/provider.dart';
import 'app_status.dart';
import 'floor_model/recorder_database/recorder_database.dart';
import 'router.dart';
import 'database_init.dart';

import 'firebase_setup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pages/login.dart';
import 'pages/leaderboards.dart';


//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await setupFirebase();
//
//   runApp(
//     DatabaseInitializer(
//       child: Builder(
//         builder: (context) {
//           final database = Provider.of<RecorderDatabase>(context, listen: false);
//           final recordingState = RecordingState(database: database);
//           return FutureBuilder(
//             future: Future.wait([
//               recordingState.loadLastStatus(),
//             ]),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return StreamBuilder<User?>(
//                   stream: FirebaseAuth.instance.authStateChanges(),
//                   builder: (BuildContext context, snapshot) {
//                     if (snapshot.hasData) {
//                       return ChangeNotifierProvider.value(
//                         value: recordingState,
//                         child: MyApp(),
//                       );
//                     } else {
//                       return MaterialApp(
//                         home: LoginPage(),
//                       );
//                     }
//                   },
//                 );
//               } else {
//                 return CircularProgressIndicator();
//               }
//             },
//           );
//         },
//       ),
//     ),
//   );
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await setupFirebase();
//
//   runApp(
//     DatabaseInitializer(
//       child: Builder(
//         builder: (context) {
//           final database = Provider.of<RecorderDatabase>(context, listen: false);
//           final recordingState = RecordingState(database: database);
//           return FutureBuilder(
//             future: Future.wait([
//               recordingState.loadLastStatus(),
//             ]),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return MaterialApp(
//                   home: LeaderboardsPage(), // Always navigate to the login page when the app starts
//                 );
//               } else {
//                 return CircularProgressIndicator();
//               }
//             },
//           );
//         },
//       ),
//     ),
//   );
// }


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
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

class MyApp extends StatefulWidget {
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void toggleTheme() {
    setState(() {
      if (currentTheme == ThemeStyle.material) {
        currentTheme = ThemeStyle.cupertino;
      } else {
        currentTheme = ThemeStyle.material;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('id', ''), // Indonesian
      ],
      locale: _locale,
    );
  }
}


// merged successfully