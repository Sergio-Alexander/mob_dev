import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mob_dev/pages/settings.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/utils/app_status.dart';

import 'package:mob_dev/floor_model/recorder_database/recorder_database.dart';
import 'package:mob_dev/floor_model/workout_recorder/workout_recorder_entity.dart';

import 'package:mob_dev/utils/app_localization.dart';
import 'package:mob_dev/utils/theme_widgets.dart';

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
  String selectedExercise = '';

  List<String> exercises = [];
  void initState(){
    super.initState();
    _loadWorkouts();
  }

  void didChangeDependencies(){
    super.didChangeDependencies();
    exercises = [
      AppLocalizations.of(context).translate('bouldering'),
      AppLocalizations.of(context).translate('benchPress'),
      AppLocalizations.of(context).translate('squats'),
      AppLocalizations.of(context).translate('400mRun'),
      AppLocalizations.of(context).translate('mountainClimbers'),
      AppLocalizations.of(context).translate('legPress'),
      AppLocalizations.of(context).translate('sitUps'),
      AppLocalizations.of(context).translate('pushUps'),
      AppLocalizations.of(context).translate('planks'),
    ];
    selectedExercise = exercises.contains(selectedExercise) ? selectedExercise : exercises[0];
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
    FirebaseFunctions.instance.httpsCallable('updatePoints').call({
      'increment': 1, // Increment the points by 1
    });


    WorkoutRecorderEntity? workout;

    final String quantity = _quantityController.text;

    if(widget.database != null){
      final points = Provider.of<RecordingState>(context, listen: false).points;
      workout = WorkoutRecorderEntity(null, selectedExercise, int.parse(quantity),points, DateTime.now());
      print('Workout ID: ${workout.workoutID}');
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

    FirebaseFunctions.instance.httpsCallable('updatePoints').call({
      'decrement': 1, // Decrement the points by 1
    });


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


  String getWorkoutName(BuildContext context, String workoutID) {
    Map<String, String> workoutNames = {
      'Bouldering': AppLocalizations.of(context).translate('bouldering'),
      'Bench Press': AppLocalizations.of(context).translate('benchPress'),
      'Squats': AppLocalizations.of(context).translate('squats'),
      '6x400m Run': AppLocalizations.of(context).translate('400mRun'),
      'Mountain Climbers': AppLocalizations.of(context).translate('mountainClimbers'),
      'Leg Press': AppLocalizations.of(context).translate('legPress'),
      'Sit Ups': AppLocalizations.of(context).translate('sitUps'),
      'Push Ups': AppLocalizations.of(context).translate('pushUps'),
      'Planks': AppLocalizations.of(context).translate('planks'),

      'Panjat Tebing': AppLocalizations.of(context).translate('bouldering'),
      'Lari 6x400m': AppLocalizations.of(context).translate('400mRun'),
    };

    return workoutNames[workoutID] ?? workoutID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('workoutRecorder')),
      ),
      body:
      Column(
        children: [
          Text(AppLocalizations.of(context).translate('selectExercise')),
          themedDropdownButton(
            context: context,
            items: exercises,
            selectedItem: selectedExercise,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedExercise = newValue;
                });
              }
            },
          ),

          Text(AppLocalizations.of(context).translate('quantity')),
          themedNumberPadField(
              controller: _quantityController,
              placeholder: AppLocalizations.of(context).translate('enterReps')
          ),
          const SizedBox(height: 16),
          currentTheme == ThemeStyle.material
              ? ElevatedButton(
            onPressed: _recordWorkout,
            child: Text(AppLocalizations.of(context).translate('logWorkout')),
          )
              : CupertinoButton(
            color: Colors.blue,
            onPressed: _recordWorkout,
            child: Text(AppLocalizations.of(context).translate('logWorkout')),
          ),
          const Divider(),
          Text(AppLocalizations.of(context).translate('workoutLogs')),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: workoutData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // title: Text(AppLocalizations.of(context).translate(workoutData[index].workoutID)),
                  title: Text(getWorkoutName(context, workoutData[index].workoutID)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${AppLocalizations.of(context).translate('amount')}: ${workoutData[index].quantity}'),
                      Text('${AppLocalizations.of(context).translate('dateAndTime')}: ${workoutData[index].timestamp.toString()}'),
                    ],
                  ),
                  trailing: themedIconButton(
                    materialIcon: Icons.delete,
                    cupertinoIcon: CupertinoIcons.trash,
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
