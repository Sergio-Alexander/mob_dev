import 'package:floor/floor.dart';
import '../date_time_converter.dart';

@Entity(tableName: "WorkoutRecorder")
class WorkoutRecorderEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String workoutID;
  final int quantity;
  final int points;

  @TypeConverters([DateTimeConverter])
  final DateTime timestamp;

  WorkoutRecorderEntity(this.id, this.workoutID, this.quantity, this.points, this.timestamp);
}