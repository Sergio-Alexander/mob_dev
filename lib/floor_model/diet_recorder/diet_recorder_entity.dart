import 'package:floor/floor.dart';

@Entity(tableName: "DietRecorder")
class DietRecorderEntity {
  @primaryKey
  final int id;
  final String diet;

  DietRecorderEntity(this.id, this.diet);
}