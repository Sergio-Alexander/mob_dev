import 'package:floor/floor.dart';
import '../date_time_converter.dart';

@Entity(tableName: "WorkoutRecorder")
class WorkoutRecorderEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String workout;
  final int quantity;
  final int points;

  @TypeConverters([DateTimeConverter])
  final DateTime timestamp;

  WorkoutRecorderEntity(this.id, this.workout, this.quantity, this.points, this.timestamp);
}