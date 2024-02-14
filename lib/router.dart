import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'emotion_recorder.dart';
import 'diet_recorder.dart';
import 'workout_recorder.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/emotion',
  routes: [
    GoRoute(
      path: '/emotion',
      builder: (BuildContext context, GoRouterState state) => EmotionRecorder(),
    ),
    GoRoute(
      path: '/diet',
      builder: (BuildContext context, GoRouterState state) => DietRecorder(),
    ),
    GoRoute(
      path: '/workout',
      builder: (BuildContext context, GoRouterState state) => WorkoutRecorder(),
    ),
    GoRoute(
      path: '/:_(.*)',
      builder: (BuildContext context, GoRouterState state) => EmotionRecorder(), // default page
    ),
  ],
);

GoRouter get appRouter => _router;