import 'package:floor/floor.dart';
import 'workout_recorder_entity.dart';

@dao
abstract class WorkoutRecorderDao {
  @Query('SELECT * FROM WorkoutRecorder')
  Future<List<WorkoutRecorderEntity>> findAllWorkoutRecorders();

  @Query('SELECT * FROM WorkoutRecorder WHERE id = :id')
  Stream<WorkoutRecorderEntity?> findWorkoutRecorderById(int id);

  @insert
  Future<int> insertWorkoutRecorder(WorkoutRecorderEntity recorder);

  @update
  Future<void> updateWorkoutRecorder(WorkoutRecorderEntity recorder);



  @delete
  Future<void> deleteWorkoutRecorder(WorkoutRecorderEntity recorder);



  @Query('SELECT * FROM WorkoutRecorder ORDER BY id DESC LIMIT 1')
  Future<WorkoutRecorderEntity?> getLastWorkout();


  @Query('SELECT COUNT(*) FROM WorkoutRecorder')
  Future<int?> countWorkouts();
}

