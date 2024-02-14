// // lib/view_models/workout_recorder_view_model.dart
// import 'package:flutter/material.dart';
// import 'package:mob_dev/app_status.dart';
//
// class WorkoutRecorderViewModel extends ChangeNotifier {
//   final TextEditingController quantityController = TextEditingController();
//   final List<Map<String, dynamic>> workoutData = [];
//   final RecordingState recordingState;
//
//   String selectedExercise = 'Bouldering';
//   final List<String> exercises = [
//     'Bouldering', 'Bench Press', 'Squats', '6x400m Run', 'Mountain Climbers',
//     'Leg Press', 'Sit Ups', 'Push Ups', 'Planks',
//   ];
//
//   WorkoutRecorderViewModel(this.recordingState);
//
//   List<Map<String, dynamic>> get workouts => workoutData;
//   String get exercise => selectedExercise;
//   List<String> get exerciseList => exercises;
//
//   void logWorkout() {
//     if (selectedExercise.isNotEmpty && quantityController.text.isNotEmpty) {
//       workoutData.insert(0, {
//         'exercise': selectedExercise,
//         'quantity': quantityController.text,
//         'datetime': DateTime.now()
//       });
//       quantityController.clear();
//       recordingState.record('Workout');
//       notifyListeners();
//     }
//   }
//
//   void clearWorkout() {
//     workoutData.clear();
//     notifyListeners();
//   }
//
//   void updateExercise(String newValue) {
//     selectedExercise = newValue;
//     notifyListeners();
//   }
// }