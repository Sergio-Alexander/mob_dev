import 'package:floor/floor.dart';
import 'workout_recorder_entity.dart';

@dao
abstract class WorkoutRecorderDao {
  @Query('SELECT * FROM workout_recorder')
  Future<List<WorkoutRecorderEntity>> findAllWorkoutRecorders();

  @Query('SELECT * FROM workout_recorder WHERE id = :id')
  Stream<WorkoutRecorderEntity> findWorkoutRecorderById(int id);

  @insert
  Future<int> insertWorkoutRecorder(WorkoutRecorderEntity recorder);

  @update
  Future<void> updateWorkoutRecorder(WorkoutRecorderEntity recorder);

  @delete
  Future<void> deleteWorkoutRecorder(WorkoutRecorderEntity recorder);
}

