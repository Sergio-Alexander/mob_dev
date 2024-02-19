import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/emotion_recorder.dart';
import 'pages/diet_recorder.dart';
import 'floor_model/recorder_database/recorder_database.dart';
import 'pages/workout_recorder.dart';

import 'package:provider/provider.dart';
import 'app_status.dart';

class ShellWidget extends StatefulWidget {
  final Widget child;

  const ShellWidget({Key? key, required this.child}) : super(key: key);

  @override
  _ShellWidgetState createState() => _ShellWidgetState();
}

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

class _ShellWidgetState extends State<ShellWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CPSC-MobDev: Sergio'),
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
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sentiment_very_satisfied), label: 'Emotion'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Diet'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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
      ],
    ),
  ],
);


GoRouter get appRouter => _router;