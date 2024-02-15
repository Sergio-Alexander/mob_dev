import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'emotion_recorder.dart';
import 'diet_recorder.dart';
import 'floor_model/recorder_database/recorder_database.dart';
import 'workout_recorder.dart';

import 'package:provider/provider.dart';
import 'app_status.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final recordingState = Provider.of<RecordingState>(context);
    return Column(
      children: [
        Text('Last Recorded: ${recordingState.lastRecordingType ?? 'None'}'),
        Text('Last Recording Time: ${recordingState.lastRecordingTime ?? 'Never'}'),
        Text('Recording Points: ${recordingState.recordingPoints}'),
        Text('Dedication Level: ${recordingState.calculateDL()}'),
      ],
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/emotion',
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(

          appBar: AppBar(
            title: Text('CPSC-MobDev: Sergio'),
            centerTitle: true,
          ),

          body: Column(
            children: [
              Expanded(child: child), // Main content of the routed pages
              StatusWidget(), // Your status widget displayed at the bottom
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.sentiment_very_satisfied), label: 'Emotion'),
              BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Diet'),
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
            ],
            onTap: (index) {
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
              }
            },
          ),
        );
      },
      routes: [
        // GoRoute(
        //   path: '/emotion',
        //   builder: (BuildContext context, GoRouterState state) => EmotionRecorder(),
        // ),

        GoRoute(
          path: '/emotion',
          builder: (BuildContext context, GoRouterState state) {
            final database = Provider.of<RecorderDatabase>(context);
            return EmotionRecorder(database: database);
          },
        ),

        GoRoute(
          path: '/diet',
          builder: (BuildContext context, GoRouterState state) => DietRecorder(),
        ),
        GoRoute(
          path: '/workout',
          builder: (BuildContext context, GoRouterState state) => WorkoutRecorder(),
        ),



        // GoRoute(
        //   path: '/diet',
        //   builder: (BuildContext context, GoRouterState state) {
        //     final database = Provider.of<RecorderDatabase>(context);
        //     return DietRecorder(database: database);
        //   },
        // ),
        // GoRoute(
        //   path: '/workout',
        //   builder: (BuildContext context, GoRouterState state) => WorkoutRecorder(),
        // ),


      ],
    ),
  ],
);


GoRouter get appRouter => _router;