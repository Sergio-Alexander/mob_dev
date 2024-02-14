import 'package:floor/floor.dart';

@Entity(tableName: "EmotionRecorder")
class EmotionRecorderEntity {
  @primaryKey
  final int id;
  final String emotion;

  EmotionRecorderEntity(this.id, this.emotion);
}