import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'emotion_recorder.dart';
import 'diet_recorder.dart';
import 'workout_recorder.dart';

final GoRouter router = GoRouter(
  initialLocation: '/emotion',
  routes: [
    GoRoute(
      path: '/emotion',
      builder: (context, state) =>  const EmotionRecorder()
    ),
  //   GoRoute(
  //     path: '/diet',
  //     pageBuilder: (context, state) => MaterialPage<void>(
  //       key: state.pageKey,
  //       child: DietRecorder(),
  //     ),
  //   ),
  //   GoRoute(
  //     path: '/workout',
  //     pageBuilder: (context, state) => MaterialPage<void>(
  //       key: state.pageKey,
  //       child: WorkoutRecorder(),
  //     ),
  //   ),
   ],
);