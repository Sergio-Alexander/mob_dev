import 'package:floor/floor.dart';
import 'app_status_entity.dart';

@dao
abstract class AppStatusDao {
  @Query('SELECT * FROM AppStatus')
  Future<List<AppStatusEntity>> findAllAppStatuses();

  @Query('SELECT * FROM AppStatus WHERE id = :id')
  Stream<AppStatusEntity?> findAppStatusById(int id);

  @insert
  Future<int> insertAppStatus(AppStatusEntity status);

  @update
  Future<void> updateAppStatus(AppStatusEntity status);

  @delete
  Future<void> deleteAppStatus(AppStatusEntity status);
}