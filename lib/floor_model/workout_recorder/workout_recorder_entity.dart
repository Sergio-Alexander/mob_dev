import 'package:floor/floor.dart';

@Entity(tableName: "WorkoutRecorder")
class WorkoutRecorderEntity {
  @primaryKey
  final int id;
  final String workout;

  WorkoutRecorderEntity(this.id, this.workout);
}