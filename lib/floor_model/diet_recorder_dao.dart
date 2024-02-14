import 'package:floor/floor.dart';
import 'diet_recorder_entity.dart';

@dao
abstract class DietRecorderDao {
  @Query('SELECT * FROM diet_recorder')
  Future<List<DietRecorderEntity>> findAllDietRecorders();

  @Query('SELECT * FROM diet_recorder WHERE id = :id')
  Stream<DietRecorderEntity> findDietRecorderById(int id);

  @insert
  Future<int> insertDietRecorder(DietRecorderEntity recorder);

  @update
  Future<void> updateDietRecorder(DietRecorderEntity recorder);

  @delete
  Future<void> deleteDietRecorder(DietRecorderEntity recorder);
}