import 'package:flutter/foundation.dart';

import '../floor_model/recorder_database/recorder_database.dart';

import 'package:mob_dev/floor_model/workout_recorder/workout_recorder_entity.dart';
import 'package:mob_dev/floor_model/diet_recorder/diet_recorder_entity.dart';
import 'package:mob_dev/floor_model/emotion_recorder/emotion_recorder_entity.dart';


class RecordingState with ChangeNotifier {
  DateTime? _lastRecordingTime;
  String? _lastRecordingType;
  int _recordingPoints = 0;

  final RecorderDatabase database;

  RecordingState({required this.database}) {
    loadLastStatus();
  }


  int get points => _recordingPoints;

  DateTime? get lastRecordingTime => _lastRecordingTime;

  String? get lastRecordingType => _lastRecordingType;

  int get recordingPoints => _recordingPoints;

  void record(String type) {
    final now = DateTime.now();

    // if more than 12 hours have passed since the last recording
    if (_lastRecordingTime != null && now
        .difference(_lastRecordingTime!)
        .inHours >= 12) {
      _recordingPoints = 0; // reset points if more than 12 hours have passed
    }

    _lastRecordingTime = now;
    _lastRecordingType = type;
    _recordingPoints += calculatePoints();
    notifyListeners();
  }

  void decreasePoints() {
    if (_recordingPoints > 0) {
      _recordingPoints--;
      notifyListeners();
    }
  }


  int calculatePoints() {
    return 1;
  }

  String calculateDL() {
    if (recordingPoints < 10) {
      return 'Level 1';
    } else if (recordingPoints < 20) {
      return 'Level 2';
    } else if (recordingPoints < 30) {
      return 'Level 3';
    } else if (recordingPoints < 40) {
      return 'Level 4';
    } else if (recordingPoints < 50) {
      return 'Level 5';
    } else if (recordingPoints < 60) {
      return 'Level 6';
    } else if (recordingPoints < 70) {
      return 'Level 7';
    } else if (recordingPoints < 80) {
      return 'Level 8';
    } else if (recordingPoints < 90) {
      return 'Level 9';
    } else if (recordingPoints < 100) {
      return 'Level 10';
    }

    return 'Level X'; // default
  }

  Future<void> loadLastStatus() async {
    try {
      // Fetch the last record from each table
      WorkoutRecorderEntity? lastWorkout = await database.workoutRecorderDao
          .getLastWorkout();
      DietRecorderEntity? lastDiet = await database.dietRecorderDao
          .getLastDiet();
      EmotionRecorderEntity? lastEmotion = await database.emotionRecorderDao
          .getLastEmotion();

      // Initialize the most recent record to the first non-null record
      DateTime? mostRecentTimestamp;
      String? mostRecentType;

      if (lastWorkout == null && lastDiet == null && lastEmotion == null) {
        _lastRecordingType = "none";
        _lastRecordingTime = null;
      } else if (lastWorkout != null) {
        mostRecentTimestamp = lastWorkout.timestamp;
        mostRecentType = 'Workout';
      } else if (lastDiet != null) {
        mostRecentTimestamp = lastDiet.timestamp;
        mostRecentType = 'Diet';
      } else if (lastEmotion != null) {
        mostRecentTimestamp = lastEmotion.timestamp;
        mostRecentType = 'Emotion';
      }

      // Compare the timestamps of the non-null records to find the most recent record
      if (lastWorkout != null && mostRecentTimestamp != null &&
          lastWorkout.timestamp.isAfter(mostRecentTimestamp)) {
        mostRecentTimestamp = lastWorkout.timestamp;
        mostRecentType = 'Workout';
      }
      if (lastDiet != null && mostRecentTimestamp != null &&
          lastDiet.timestamp.isAfter(mostRecentTimestamp)) {
        mostRecentTimestamp = lastDiet.timestamp;
        mostRecentType = 'Diet';
      }
      if (lastEmotion != null && mostRecentTimestamp != null &&
          lastEmotion.timestamp.isAfter(mostRecentTimestamp)) {
        mostRecentTimestamp = lastEmotion.timestamp;
        mostRecentType = 'Emotion';
      }


      int? workoutPoints = await database.workoutRecorderDao.countWorkouts();
      int? dietPoints = await database.dietRecorderDao.countDiets();
      int? emotionPoints = await database.emotionRecorderDao.countEmotions();

      _lastRecordingTime = mostRecentTimestamp;
      _lastRecordingType = mostRecentType;
      _recordingPoints =
          (workoutPoints ?? 0) + (dietPoints ?? 0) + (emotionPoints ?? 0);
    } catch (e) {
      print('Error: $e');
    }

    notifyListeners();
  }
}


