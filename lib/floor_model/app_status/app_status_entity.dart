import 'package:floor/floor.dart';

@Entity(tableName: 'AppStatus')
class AppStatusEntity {
  @primaryKey
  final int id;
  final String status;
  final int points;

  AppStatusEntity(this.id, this.status, this.points);
}