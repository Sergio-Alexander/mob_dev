import 'package:floor/floor.dart';
import 'date_time_converter.dart';

@Entity(tableName: "EmotionRecorder")
class EmotionRecorderEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String emoji;
  final int points;

  @TypeConverters([DateTimeConverter])
  final DateTime timestamp;

  EmotionRecorderEntity(this.id, this.emoji, this.points, this.timestamp);
}