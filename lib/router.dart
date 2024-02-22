import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/emotion_recorder.dart';
import 'pages/diet_recorder.dart';
import 'floor_model/recorder_database/recorder_database.dart';
import 'pages/workout_recorder.dart';

import 'package:provider/provider.dart';
import 'app_status.dart';

import 'package:mob_dev/pages/settings.dart';
import 'app_localization.dart';

class ShellWidget extends StatefulWidget {
  final Widget child;

  const ShellWidget({Key? key, required this.child}) : super(key: key);

  @override
  _ShellWidgetState createState() => _ShellWidgetState();
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key});

  String getLastRecordingType(BuildContext context, String? lastRecordingType) {
    Map<String, String> recordingTypes = {
      'Emotion': AppLocalizations.of(context).translate('emotion'),
      'Diet': AppLocalizations.of(context).translate('diet'),
      'Workout': AppLocalizations.of(context).translate('workout'),
    };

    return recordingTypes[lastRecordingType] ?? AppLocalizations.of(context).translate('none');
  }

  @override
  Widget build(BuildContext context) {
    final recordingState = Provider.of<RecordingState>(context);
    return Column(
      children: [
        // Text(AppLocalizations.of(context).translate('lastRecorded') + ': ${recordingState.lastRecordingType ?? AppLocalizations.of(context).translate('none')}'),
        Text(AppLocalizations.of(context).translate('lastRecorded') + ': ${getLastRecordingType(context, recordingState.lastRecordingType)}'),
        Text(AppLocalizations.of(context).translate('lastRecordingTime') + ': ${recordingState.lastRecordingTime ?? AppLocalizations.of(context).translate('never')}'),
        Text(AppLocalizations.of(context).translate('recordingPoints') + ': ${recordingState.recordingPoints}'),
        Text(AppLocalizations.of(context).translate('dedicationLevel') + ': ${recordingState.calculateDL()}'),
      ],
    );
  }
}

class _ShellWidgetState extends State<ShellWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('appTitle')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: widget.child),
          StatusWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              context.go('/emotion');
              break;
            case 1:
              context.go('/diet');
              break;
            case 2:
              context.go('/workout');
              break;
            case 3:
              context.go('/settings');
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.sentiment_very_satisfied), label: AppLocalizations.of(context).translate('emotion')),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: AppLocalizations.of(context).translate('diet')),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: AppLocalizations.of(context).translate('workout')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: AppLocalizations.of(context).translate('settings')),
        ],
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/emotion',
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ShellWidget(child: child);
      },
      routes: [
        GoRoute(
          path: '/emotion',
          builder: (BuildContext context, GoRouterState state) {
            final database = Provider.of<RecorderDatabase>(context);
            return EmotionRecorder(database: database);
          },
        ),

        GoRoute(
          path: '/diet',
          builder: (BuildContext context, GoRouterState state) {
            final database = Provider.of<RecorderDatabase>(context);
            return DietRecorder(database: database);
          }
        ),
        GoRoute(
          path: '/workout',
          builder: (BuildContext context, GoRouterState state) {
            final database = Provider.of<RecorderDatabase>(context);
            return WorkoutRecorder(database: database);
          }
        ),
        GoRoute(
            path: '/settings',
            builder: (BuildContext context, GoRouterState state) {
              return SettingsPage();
            }
        ),
      ],
    ),
  ],
);


GoRouter get appRouter => _router;