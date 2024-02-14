import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'emotion_recorder_entity.dart';
import 'workout_recorder_entity.dart';
import 'diet_recorder_entity.dart';
import 'emotion_recorder_dao.dart';
import 'workout_recorder_dao.dart';
import 'diet_recorder_dao.dart';

part 'recorder_database.g.dart';

@Database(version: 1, entities: [EmotionRecorderEntity, WorkoutRecorderEntity, DietRecorderEntity])
abstract class RecorderDatabase extends FloorDatabase {
  EmotionRecorderDao get emotionRecorderDao;
  WorkoutRecorderDao get workoutRecorderDao;
  DietRecorderDao get dietRecorderDao;
}