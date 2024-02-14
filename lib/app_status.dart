import 'package:flutter/foundation.dart';

class RecordingState with ChangeNotifier {
  DateTime? _lastRecordingTime;
  String? _lastRecordingType;
  int _recordingPoints = 0;

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
