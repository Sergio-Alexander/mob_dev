import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/app_status.dart';

import 'package:mob_dev/floor_model/recorder_database/recorder_database.dart';
import 'package:mob_dev/floor_model/workout_recorder/workout_recorder_entity.dart';

class WorkoutRecorder extends StatefulWidget {
  final RecorderDatabase? database;
  const WorkoutRecorder({Key? key, this.database}):super(key:key);

  @override
  _WorkoutRecorder createState() => _WorkoutRecorder();
}

class _WorkoutRecorder extends State<WorkoutRecorder> {
  List<WorkoutRecorderEntity> workoutData =[];
  final TextEditingController _quantityController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  // final List<Map<String, dynamic>> workoutData = [];


  String selectedExercise = 'Bouldering';
  final List<String> exercises = [
    'Bouldering', 'Bench Press', 'Squats', '6x400m Run', 'Mountain Climbers',
    'Leg Press', 'Sit Ups', 'Push Ups', 'Planks',
  ];

  void initState(){
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    if(widget.database != null){
      final workouts = await widget.database!.workoutRecorderDao.findAllWorkoutRecorders();
      setState(() {
        workoutData = workouts;
      });
    }
  }

  Future<void> _recordWorkout() async {
    WorkoutRecorderEntity? workout;

    final String quantity = _quantityController.text;

    if(widget.database != null){
      final points = Provider.of<RecordingState>(context, listen: false).points;
      workout = WorkoutRecorderEntity(null, selectedExercise, int.parse(quantity),points, DateTime.now());

    }

    if (workout != null){
      try{
        await widget.database!.workoutRecorderDao.insertWorkoutRecorder(workout);
        await _loadWorkouts();

        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
        _quantityController.clear();
        FocusScope.of(context).unfocus();
      } catch (e) {
        print('Error: $e');
      }
    }
    Provider.of<RecordingState>(context, listen: false).record('Workout');
  }

  Future<void> _deleteWorkout(WorkoutRecorderEntity workout) async {
    if(widget.database != null){
      try{
        await widget.database!.workoutRecorderDao.deleteWorkoutRecorder(workout);
        Provider.of<RecordingState>(context, listen: false).decreasePoints();
        await Provider.of<RecordingState>(context, listen: false).loadLastStatus();
        await _loadWorkouts();
      } catch (e){
        print('Error: $e');
      }
    }
  }



  void _clearWorkout() {
    setState(() {
      workoutData.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Workout Recorder'),
      ),
      body: Column(
        children: [
          const Text('Select Exercise'),
          DropdownButton<String>(
            value: selectedExercise,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedExercise = newValue;
                });
              }
            },
            items: exercises.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const Text('Quantity'),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter Reps',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _recordWorkout, // Use _recordWorkout instead of _logWorkout
            child: const Text('Log Workout'),
          ),
          // ElevatedButton(
          //   onPressed: _clearWorkout,
          //   child: const Text('Clear Logs'),
          // ),
          const Divider(),
          const Text('Workout Logs'),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: workoutData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(workoutData[index].workout),
                  subtitle:
                  // Text(
                  //   'Quantity: ${workoutData[index].quantity}',
                  //   key: Key('quantity_${workoutData[index].quantity}'), // Add a key
                  // ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount: ${workoutData[index].quantity}'),
                      Text('Date and Time: ${workoutData[index].timestamp.toString()}'),

                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteWorkout(workoutData[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
