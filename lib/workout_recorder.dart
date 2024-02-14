import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/app_status.dart';

class WorkoutRecorder extends StatefulWidget {
  const WorkoutRecorder({super.key});

  @override
  _WorkoutRecorder createState() => _WorkoutRecorder();
}

class _WorkoutRecorder extends State<WorkoutRecorder> {
  final TextEditingController _quantityController = TextEditingController();
  final List<Map<String, dynamic>> workoutData = [];

  String selectedExercise = 'Bouldering';
  final List<String> exercises = [
    'Bouldering', 'Bench Press', 'Squats', '6x400m Run', 'Mountain Climbers',
    'Leg Press', 'Sit Ups', 'Push Ups', 'Planks',
  ];

  void _logWorkout() {
    final String quantity = _quantityController.text;
    if (selectedExercise.isNotEmpty && quantity.isNotEmpty) {
      setState(() {
        workoutData.insert(0, {
          'exercise': selectedExercise,
          'quantity': quantity,
          'datetime': DateTime.now()
        });
      });

      Provider.of<RecordingState>(context, listen: false).record('Workout');
      _quantityController.clear();
    }else {
      // Show an alert or some feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter reps'),
        ),
      );
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
          title: const Text('Workout Recorder')),
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
            onPressed: _logWorkout,
            child: const Text('Log Workout'),
          ),
          ElevatedButton(
            onPressed: _clearWorkout,
            child: const Text('Clear Logs'),
          ),
          const Divider(),
          const Text('Workout Logs'),
          Expanded(
            child: ListView.builder(
              itemCount: workoutData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(workoutData[index]['exercise']),
                  subtitle: Text(
                    'Quantity: ${workoutData[index]['quantity']}',
                    key: Key('quantity_${workoutData[index]['quantity']}'), // Add a key
                  ),
                  trailing: Text(
                    'Logged on: ${workoutData[index]['datetime'].toString()}',
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
