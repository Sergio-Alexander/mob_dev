import 'package:floor/floor.dart';
import '../date_time_converter.dart';

@Entity(tableName: 'AppStatus')
class AppStatusEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String whichRecorder;


  @TypeConverters([DateTimeConverter])
  final DateTime timestamp;

  AppStatusEntity(this.id, this.whichRecorder, this.timestamp);
}