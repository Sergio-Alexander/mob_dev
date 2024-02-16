import 'package:floor/floor.dart';
import 'diet_recorder_entity.dart';

@dao
abstract class DietRecorderDao {
  @Query('SELECT * FROM DietRecorder')
  Future<List<DietRecorderEntity>> findAllDietRecorders();

  @Query('SELECT * FROM DietRecorder WHERE id = :id')
  Stream<DietRecorderEntity?> findDietRecorderById(int id);

  @insert
  Future<int> insertDietRecorder(DietRecorderEntity recorder);

  @update
  Future<void> updateDietRecorder(DietRecorderEntity diet);

  @delete
  Future<void> deleteDietRecorder(DietRecorderEntity recorder);



  @Query('SELECT * FROM DietRecorder ORDER BY id DESC LIMIT 1')
  Future<DietRecorderEntity?> getLastDiet();



  @Query('SELECT COUNT(*) FROM DietRecorder')
  Future<int?> countDiets();
}