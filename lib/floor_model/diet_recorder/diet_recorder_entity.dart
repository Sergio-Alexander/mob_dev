import 'package:floor/floor.dart';
import '../date_time_converter.dart';

@Entity(tableName: "DietRecorder")
class DietRecorderEntity {
  @PrimaryKey(autoGenerate: true)
  final int?id;
  final String diet;
  final int amount;
  final int points;

  @TypeConverters([DateTimeConverter])
  final DateTime timestamp;

  DietRecorderEntity(this.id, this.diet, this.amount, this.points, this.timestamp);

  DietRecorderEntity copyWith({
    int? id,
    String? diet,
    int? amount,
    int? points,
    DateTime? timestamp,
  }) {
    return DietRecorderEntity(
      id ?? this.id,
      diet ?? this.diet,
      amount ?? this.amount,
      points ?? this.points,
      timestamp ?? this.timestamp,
    );
  }

}