import 'package:flutter/foundation.dart';

import 'floor_model/recorder_database/recorder_database.dart';

class RecordingState with ChangeNotifier {
  DateTime? _lastRecordingTime;
  String? _lastRecordingType;
  int _recordingPoints = 0;

  int get points => _recordingPoints;

  DateTime? get lastRecordingTime => _lastRecordingTime;
  String? get lastRecordingType => _lastRecordingType;
  int get recordingPoints => _recordingPoints;

  void record(String type) {
    final now = DateTime.now();

    // if more than 12 hours have passed since the last recording
    if (_lastRecordingTime != null && now.difference(_lastRecordingTime!).inHours >= 12) {
      _recordingPoints = 0; // reset points if more than 12 hours have passed
    }

    _lastRecordingTime = now;
    _lastRecordingType = type;
    _recordingPoints += calculatePoints();
    notifyListeners();
  }

  // Future<void> loadLastRecordedData() async {
  //   // Assuming a generalized method in your DAO that fetches the latest record across all types
  //   final database = await $FloorRecorderDatabase.databaseBuilder('recorder_database.db').build();
  //   final lastRecord = await database.generalDao.findLastRecord();
  //   if (lastRecord != null) {
  //     // Update your state based on the type of the last record
  //     // This requires your database model to differentiate between record types
  //     _lastRecordingType = lastRecord.type; // 'Emotion', 'Diet', 'Workout'
  //     _lastRecordingTime = lastRecord.timestamp;
  //     notifyListeners();
  //   }
  // }


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
}
