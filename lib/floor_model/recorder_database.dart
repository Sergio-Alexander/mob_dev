import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'date_time_converter.dart';

import 'emotion_recorder_entity.dart';
import 'emotion_recorder_dao.dart';

import 'workout_recorder_entity.dart';
import 'workout_recorder_dao.dart';

import 'diet_recorder_entity.dart';
import 'diet_recorder_dao.dart';

import 'app_status_entity.dart';
import 'app_status_dao.dart';



part 'recorder_database.g.dart';

// typeConverters: [DateTimeConverter]

@Database(version: 1, entities:
[
  EmotionRecorderEntity,
  // WorkoutRecorderEntity,
  // DietRecorderEntity,
  // AppStatusEntity
],
    // typeConverters: [DateTimeConverter]
)

abstract class RecorderDatabase extends FloorDatabase {
  EmotionRecorderDao get emotionRecorderDao;
  // WorkoutRecorderDao get workoutRecorderDao;
  // DietRecorderDao get dietRecorderDao;
  // AppStatusDao get appStatusDao;
}